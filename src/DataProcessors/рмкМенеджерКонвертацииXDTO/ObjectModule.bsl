#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьДоступныеМетоды(Направление) Экспорт
	
	ИменаМетодов = Новый Массив;
	
	Если Направление = "Входящее" Тогда
		ИменаМетодов.Добавить("ВходящиеСообщения_Прочитать");
	Иначе
		ИменаМетодов.Добавить("ИсходящиеСообщения_Сформировать");
	КонецЕсли;
	
	Возврат ИменаМетодов;
	
КонецФункции

Процедура ВыполнитьМетод(ИмяМетода, Параметры) Экспорт
	
	Если ИмяМетода = "ИсходящиеСообщения_Сформировать" Тогда
		ИсходящиеСообщения_Сформировать(Параметры);
	ИначеЕсли ИмяМетода = "ВходящиеСообщения_Прочитать" Тогда
		ВходящиеСообщения_Прочитать(Параметры);
	Иначе
		ВызватьИсключение СтрШаблон("Не найден метод конвертации %1", ИмяМетода);
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИсходящиеСообщения_Сформировать(Параметры)
	
	ОбъектДляСериализации	= Параметры.ОбъектДляСериализации;
	ДанныеСообщения 		= Параметры.ДанныеСообщения;
	
	Если рмкОбщегоНазначения.ЭтоДокумент(ОбъектДляСериализации) Тогда
		ПрочитатьДвиженияВДокумент(ОбъектДляСериализации);
	КонецЕсли;
	
	// задействуем платформенную сериализацию
	ДанныеСообщения.Вставить("SerializationMetod", 	"SerializationMetod_1CXDTO");
	ДанныеСообщения.Вставить("Content", 			ОбъектДляСериализации);
	
КонецПроцедуры	

Процедура ПрочитатьДвиженияВДокумент(ДокументОбъект)
	
	Для Каждого НаборДвижений Из ДокументОбъект.Движения Цикл
		НаборДвижений.Прочитать();
	КонецЦикла	
	
КонецПроцедуры		

Процедура ВходящиеСообщения_Прочитать(КонтейнерСообщения)
	
	Объект = КонтейнерСообщения.Content;
	УстановитьДополнительныеПараметрыЗаписиОбъета(Объект);
	Объект.Записать();
	
	Если рмкОбщегоНазначения.ЭтоДокумент(Объект) И Объект.Проведен Тогда
		РегистрыСведений.рмкДокументыКОтложенномуПроведению.ДобавитьВОчередь(Объект.Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

Процедура УстановитьДополнительныеПараметрыЗаписиОбъета(ЗаписываемыйОбъект)
	
	ЗаписываемыйОбъект.ОбменДанными.Загрузка = Истина;
		
КонецПроцедуры	

#КонецОбласти

#КонецЕсли