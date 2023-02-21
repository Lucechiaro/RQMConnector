#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

Процедура ПриЗаписиОбъектаРепликации(Источник, Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Если рмкОбщегоНазначенияПереопределяемый.ОбъектИсключенИзРепликации(Источник.Метаданные()) Тогда
		Возврат;
	КонецЕсли;		
	
	Для Каждого ТочкаПодключения Из ТочкиПодключенияДляОбъекта(Источник) Цикл
		СоздатьИсходящееСообщение(Источник, ТочкаПодключения);
	КонецЦикла;	
	
КонецПроцедуры

Процедура ПриЗаписиРегистраРепликации(Источник, Отказ, Замещение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Для Каждого ТочкаПодключения Из ТочкиПодключенияДляОбъекта(Источник) Цикл
		СоздатьИсходящееСообщение(Источник, ТочкаПодключения);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРегламентныхЗаданий

Процедура ВыполнитьРегламентОтправкиИсходящихСообщений() Экспорт
	
	рмкОбщегоНазначенияПереопределяемый.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.рмкОтправкаИсходящихСообщений);
	
	ТаблицаСообщений = ПолучитьСообщенияДляОтправки();
	ОтправитьСообщения(ТаблицаСообщений);
	
КонецПроцедуры

Процедура ПолучитьСообщенияИзОчередей(СлушателиОчередей = Неопределено) Экспорт
	
	рмкОбщегоНазначенияПереопределяемый.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.рмкПолучениеСообщенийИзОчередей);
	
	Если СлушателиОчередей = Неопределено Тогда
		СлушателиОчередей = ПолучитьАктивныеСлушателиОчередей();
	КонецЕсли;	
	
	Коннектор = Обработки.рмкКоннектор.Создать();
	Коннектор.Инициализировать();
	
	Для Каждого СлушательОчереди Из СлушателиОчередей Цикл
		
		Попытка
			
			// TODO переработать обработку исключений. Обрабатывать отдельно исключение при подключении
			// и отдельно исключение при получении сообщений из очереди
			Коннектор.Подключиться(СлушательОчереди.ВиртуальныйХост);
				
		Исключение

			ОписаниеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации("RMQConnector.Ошибка получения сообщений", УровеньЖурналаРегистрации.Ошибка, , СлушательОчереди, ОписаниеОшибки);
			ИмяОчереди = рмкОбщегоНазначенияПереопределяемый.ЗначениеРеквизитаОбъекта(СлушательОчереди, "ИмяОчереди");
			ВызватьИсключение СтрШаблон("Не удалось подключиться к очереди %1", ИмяОчереди);
			
		КонецПопытки;
		
		Коннектор.ПолучитьСообщенияИзОчереди(СлушательОчереди);
		
	КонецЦикла;
	 
	Коннектор.Закрыть();
	
КонецПроцедуры

Процедура ВыполнитьРегламентОбработкиВходящихСообщений() Экспорт
	
	ВходящиеСообщения = ПолучитьВходящиеСообщения();
	ОбработатьВходящиеСообщения(ВходящиеСообщения);
	
КонецПроцедуры

Процедура ОчиститьУстаревшиеСообщения() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КоличествоДнейХранения = Константы.рмкДнейХраненияСообщений.Получить();
	
	Если КоличествоДнейХранения = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СекундВСутках = 86400;
	ДатаУстареванияСообщений = ТекущаяДатаСеанса() - КоличествоДнейХранения * СекундВСутках;
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	рмкВходящиеСообщения.Ссылка Как Сообщение
	|ИЗ
	|	Справочник.рмкВходящиеСообщения КАК рмкВходящиеСообщения
	|ГДЕ
	|	рмкВходящиеСообщения.ДатаПолучения < &ДатаУстареванияСообщений
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	рмкИсходящиеСообщения.Ссылка
	|ИЗ
	|	Справочник.рмкИсходящиеСообщения КАК рмкИсходящиеСообщения
	|ГДЕ
	|	рмкИсходящиеСообщения.ДатаСоздания < &ДатаУстареванияСообщений";
	Запрос.УстановитьПараметр("ДатаУстареванияСообщений", ДатаУстареванияСообщений);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		УдалитьСообщениеОбмена(Выборка.Сообщение);
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти 

Процедура ОбработатьВходящиеСообщения(ВходящиеСообщения) Экспорт
	
	МенеджерыКонвертации = СоздатьМенеджерыКонвертации();

	Для Каждого Сообщение Из ВходящиеСообщения Цикл
				
		Если Сообщение.МенеджерКонвертации.Пустая() Или ПустаяСтрока(Сообщение.ИмяМетодаКонвертации) Тогда
			Продолжить;
		КонецЕсли;	
				
		МенеджерКонвертации = ПолучитьМенеджерКонвертации(МенеджерыКонвертации, Сообщение.МенеджерКонвертации);
		ДанныеДляРаспаковки = Сообщение.Данные.Получить();
		
		Если ДанныеДляРаспаковки = Неопределено Тогда
			
			ЗафиксироватьСтатусСообщения(Сообщение, "Ошибка", "Сообщение не содержит данные");
			Продолжить;
			
		КонецЕсли;	
		
		КонтейнерСообщения = рмкОбщегоНазначения.ДесериализоватьОбъект(ДанныеДляРаспаковки);

		Попытка 
			
			МенеджерКонвертации.ВыполнитьМетод(Сообщение.ИмяМетодаКонвертации, КонтейнерСообщения);
			ЗафиксироватьСтатусСообщения(Сообщение, "Обработано");
			
		Исключение
			
			ПодробноеПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗафиксироватьСтатусСообщения(Сообщение, "Ошибка", ПодробноеПредставлениеОшибки);
			
		КонецПопытки;	
			
	КонецЦикла;	
	
КонецПроцедуры

// таблица сообщений должна содержать колонки
// сообщение (ссылка), сервер, виртуальный хост, универсальная дата создания
Процедура ОтправитьСообщения(ТаблицаСообщений) Экспорт
	
	ТаблицаСообщений.Сортировать("Сервер,ВиртуальныйХост,УниверсальнаяДатаСоздания");
	ТаблицаХостов = ТаблицаСообщений.Скопировать();
	ТаблицаХостов.Свернуть("Сервер,ВиртуальныйХост");
	Отбор = Новый Структура("Сервер,ВиртуальныйХост");
	
	Коннектор = Обработки.рмкКоннектор.Создать();
	Коннектор.Инициализировать();
	
	Для Каждого СтрокаХоста Из ТаблицаХостов Цикл
		
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаХоста);
		СообщенияКОтправке = ТаблицаСообщений.НайтиСтроки(Отбор);

		Коннектор.Подключиться(СтрокаХоста.ВиртуальныйХост);
		
		Для Каждого СтрокаСообщения Из СообщенияКОтправке Цикл
			Коннектор.ОтправитьСообщение(СтрокаСообщения.Сообщение);
		КонецЦикла;	
		
	КонецЦикла;	
	
	Коннектор.Закрыть();
	
КонецПроцедуры

Процедура ЗафиксироватьСтатусСообщения(Сообщение, СтатусСтрокой, Информация = "", ЗаписыватьСообщение = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(СтатусСтрокой) = Тип("Строка") Тогда
		Статус = ПредопределенноеЗначение("Перечисление.рмкСтатусыСообщений." + СтатусСтрокой);
	Иначе
		Статус = СтатусСтрокой;
	КонецЕсли;			
	
	Если ЗаписыватьСообщение = Истина Тогда
		
		СообщениеОбъект = Сообщение.ПолучитьОбъект();
		СообщениеОбъект.ТекущийСтатус = Статус;
		СообщениеОбъект.Записать();
		
	КонецЕсли;	
	
	МенеджерЗаписи = РегистрыСведений.рмкСтатусыСообщений.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период	 		= ТекущаяДатаСеанса();
	МенеджерЗаписи.Сообщение 		= Сообщение;
	МенеджерЗаписи.Идентификатор 	= Новый УникальныйИдентификатор;
	МенеджерЗаписи.Статус 			= Статус;
	МенеджерЗаписи.Информация 		= Информация;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Функция ПолучитьМенеджерКонвертации(Менеджеры = Неопределено, ТипМенеджера) Экспорт
	
	Если Менеджеры = Неопределено Тогда
		Менеджеры = СоздатьМенеджерыКонвертации();
	КонецЕсли;	
	
	МенеджерКонвертации = Менеджеры.Получить(ТипМенеджера);
	
	Если МенеджерКонвертации = Неопределено Тогда
		ВызватьИсключение СтрШаблон("Не инициализирован менеджер конвертации %1", ТипМенеджера);
	КонецЕсли;
	
	Возврат МенеджерКонвертации;
	
КонецФункции	

#КонецОбласти 
	
#Область СлужебныеПроцедурыИФункции

Функция ТочкиПодключенияДляОбъекта(Источник)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПолноеИмяМетаданных = Источник.Метаданные().ПолноеИмя();
	ТочкиПодключения 	= Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	рмкТочкиПодключения.Ссылка Как ТочкаПодключения
	|ИЗ
	|	Справочник.рмкТочкиПодключения.МетаданныеДляРепликации КАК рмкТочкиПодключенияМетаданныеДляРепликации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.рмкТочкиПодключения КАК рмкТочкиПодключения
	|		ПО рмкТочкиПодключенияМетаданныеДляРепликации.Ссылка = рмкТочкиПодключения.Ссылка
	|ГДЕ
	|	НЕ рмкТочкиПодключения.ПометкаУдаления
	|	И рмкТочкиПодключения.Активна
	|	И рмкТочкиПодключенияМетаданныеДляРепликации.ПолноеИмя = &ПолноеИмяМетаданных";
	Запрос.УстановитьПараметр("ПолноеИмяМетаданных", ПолноеИмяМетаданных);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ТочкиПодключения.Добавить(Выборка.ТочкаПодключения);
	КонецЦикла;	
	
	Возврат ТочкиПодключения;
	
КонецФункции

Функция ПолучитьАктивныеСлушателиОчередей()
	
	СлушателиОчередей = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	рмкСлушателиОчередей.Ссылка Как Слушатель
	|ИЗ
	|	Справочник.рмкСлушателиОчередей КАК рмкСлушателиОчередей
	|ГДЕ
	|	рмкСлушателиОчередей.Активен
	|	И НЕ рмкСлушателиОчередей.ПометкаУдаления";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СлушателиОчередей.Добавить(Выборка.Слушатель);
	КонецЦикла;	
	
	Возврат СлушателиОчередей;
	
КонецФункции

Функция ПолучитьВходящиеСообщения()
	
	ВходящиеСообщения = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	рмкВходящиеСообщения.Ссылка
	|ИЗ
	|	Справочник.рмкВходящиеСообщения КАК рмкВходящиеСообщения
	|ГДЕ
	|	рмкВходящиеСообщения.ТекущийСтатус <> Значение(Перечисление.рмкСтатусыСообщений.Обработано)
	|	И НЕ рмкВходящиеСообщения.ПометкаУдаления";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВходящиеСообщения.Добавить(Выборка.Ссылка);
	КонецЦикла;	
		
	Возврат ВходящиеСообщения;
	
КонецФункции

Процедура СоздатьИсходящееСообщение(ОбъектДляСериализации, ТочкаПодключения)
	
	ID = Строка(Новый УникальныйИдентификатор);
	РеквизитыТочки = рмкОбщегоНазначенияПереопределяемый.ЗначенияРеквизитовОбъекта(ТочкаПодключения, "Сервер,ВиртуальныйХост");
	
	СообщениеОбъект = Справочники.рмкИсходящиеСообщения.СоздатьЭлемент();
	СообщениеОбъект.ТекущийСтатус 		= ПредопределенноеЗначение("Перечисление.рмкСтатусыСообщений.Создано");
	СообщениеОбъект.Сервер 				= РеквизитыТочки.Сервер;
	СообщениеОбъект.ТочкаПодключения 	= ТочкаПодключения;
	СообщениеОбъект.ВиртуальныйХост 	= РеквизитыТочки.ВиртуальныйХост;
	СообщениеОбъект.Код = ID;
	СообщениеОбъект.ПредставлениеДанных = Строка(ОбъектДляСериализации);
	СообщениеОбъект.ПредставлениеМетаданных = рмкОбщегоНазначения.ПолучитьПредставлениеМетаданныхОбъекта(ОбъектДляСериализации);;
	
	ДанныеСообщения 		= ПолучитьДанныеСообщения(ОбъектДляСериализации, СообщениеОбъект, ТочкаПодключения);
	КонтейнерСообщения 		= рмкОбщегоНазначения.СериализоватьОбъект(ДанныеСообщения);
	СообщениеОбъект.Данные 	= Новый ХранилищеЗначения(КонтейнерСообщения);
	СообщениеОбъект.Записать();
	
	ЗафиксироватьСтатусСообщения(СообщениеОбъект.Ссылка, "Создано");
	
КонецПроцедуры	

Процедура СоздатьВходящееСообщение(СлушательОчереди, ПрочитанноеСообщение) Экспорт
	
	СписокРеквизитов = "Сервер,ВиртуальныйХост,ИмяОчереди,МенеджерКонвертации,ИмяМетодаКонвертации";
	РеквизитыСлушателя = рмкОбщегоНазначенияПереопределяемый.ЗначенияРеквизитовОбъекта(СлушательОчереди, СписокРеквизитов);
	Статус = ПредопределенноеЗначение("Перечисление.рмкСтатусыСообщений.Получено");
	
	СообщениеОбъект = Справочники.рмкВходящиеСообщения.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(СообщениеОбъект, РеквизитыСлушателя);
	СообщениеОбъект.Данные 			= Новый ХранилищеЗначения(ПрочитанноеСообщение);
	СообщениеОбъект.ТекущийСтатус 	= Статус;
	СообщениеОбъект.ДатаПолучения 	= ТекущаяДатаСеанса();
		
	//@skip-check empty-except-statement
	Попытка
		
		КонтейнерСообщения = рмкОбщегоНазначения.ДесериализоватьОбъект(ПрочитанноеСообщение);
		
		Если ТипЗнч(КонтейнерСообщения) = Тип("Структура") Тогда
			
			КонтейнерСообщения.Свойство("MetadataPresentation", СообщениеОбъект.ПредставлениеМетаданных);
			КонтейнерСообщения.Свойство("DataPresentation", СообщениеОбъект.ПредставлениеДанных);
			
		КонецЕсли;	
		
	Исключение
		
	КонецПопытки;		
	
	СообщениеОбъект.Записать();
	
	ЗафиксироватьСтатусСообщения(СообщениеОбъект.Ссылка, Статус, "", Истина);
	
КонецПроцедуры

Функция ПолучитьДанныеСообщения(ОбъектДляСериализации, Сообщение, ТочкаПодключения) 
	
	ДанныеСообщения = Новый Структура; 
	ДанныеСообщения.Вставить("ID", 						Сообщение.Код);
	ДанныеСообщения.Вставить("MetadataPresentation", 	Сообщение.ПредставлениеМетаданных);
	ДанныеСообщения.Вставить("DataPresentation", 		Сообщение.ПредставлениеДанных);
				
	МенеджерыКонвертации 	= СоздатьМенеджерыКонвертации();
	МенеджерКонвертации 	= МенеджерыКонвертации.Получить(ТочкаПодключения.МенеджерКонвертации);
	ПараметрыКонвертации 	= Новый Структура("ОбъектДляСериализации, ДанныеСообщения", ОбъектДляСериализации, ДанныеСообщения);

	МенеджерКонвертации.ВыполнитьМетод(ТочкаПодключения.ИмяМетодаКонвертации, ПараметрыКонвертации);

	Возврат ДанныеСообщения;
	
КонецФункции

Функция ПолучитьСообщенияДляОтправки()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	рмкИсходящиеСообщения.Ссылка Как Сообщение,
	|	рмкИсходящиеСообщения.Сервер,
	|	рмкИсходящиеСообщения.ВиртуальныйХост КАК ВиртуальныйХост,
	|	рмкИсходящиеСообщения.УниверсальнаяДатаСоздания КАК УниверсальнаяДатаСоздания
	|ИЗ
	|	Справочник.рмкИсходящиеСообщения КАК рмкИсходящиеСообщения
	|ГДЕ
	|	рмкИсходящиеСообщения.ТекущийСтатус = Значение(Перечисление.рмкСтатусыСообщений.Создано)
	|	И НЕ рмкИсходящиеСообщения.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВиртуальныйХост,
	|	УниверсальнаяДатаСоздания";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции	

#Область ПодключениеМенеджеровКонвертации

Процедура ПодключитьВнешнююОбработкуМенеджераКонвертации()
	
	ДвоичныеДанныеОбработки = Константы.рмкХранилищеПодключаемогоМенеджераКонвертации.Получить().Получить();
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("epf");
	ДвоичныеДанныеОбработки.Записать(ИмяВременногоФайла);
	АдресОбработки = ПоместитьВоВременноеХранилище(ДвоичныеДанныеОбработки);
	УдалитьФайлы(ИмяВременногоФайла);
	ВнешниеОбработки.Подключить(АдресОбработки, "рмкМенеджерКонвертации", Ложь);
	
КонецПроцедуры

Функция СоздатьМенеджерыКонвертации()
	
	Менеджеры = Новый Соответствие;
	Менеджеры.Вставить(ПредопределенноеЗначение("Перечисление.рмкМенеджерыКонвертации.МенеджерXDTO"), Обработки.рмкМенеджерКонвертацииXDTO.Создать());
	Менеджеры.Вставить(ПредопределенноеЗначение("Перечисление.рмкМенеджерыКонвертации.ВстроенныйМенеджер"), Обработки.рмкМенеджерКонвертации.Создать());
	
	Если рмкОбщегоНазначения.ПодключаемыйМенеджерКонвертацииЗагружен() Тогда
	
		ПодключитьВнешнююОбработкуМенеджераКонвертации();
		Менеджеры.Вставить(ПредопределенноеЗначение("Перечисление.рмкМенеджерыКонвертации.ПодключаемыйМенеджер"), ВнешниеОбработки.Создать("рмкМенеджерКонвертации"));
		
	КонецЕсли;
	
	Возврат Менеджеры;
	
КонецФункции

Процедура УдалитьСообщениеОбмена(Сообщение)
	
	СообщениеОбъект = Сообщение.ПолучитьОбъект();
	СообщениеОбъект.Удалить();
	// регистр сведений "рмкСтатусыСообщений" очистится автоматически, так измерение "Сообщение" - ведущее
		
КонецПроцедуры	

#КонецОбласти 

#КонецОбласти 