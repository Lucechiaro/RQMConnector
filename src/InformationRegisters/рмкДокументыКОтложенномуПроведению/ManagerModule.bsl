#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ДобавитьВОчередь(Документ, Дата = Неопределено, ОписаниеОшибки = "") Экспорт
	
	ЗаписиРегистра = СоздатьНаборЗаписей();
	ЗаписиРегистра.Отбор.Документ.Установить(Документ);
	
	Запись = ЗаписиРегистра.Добавить();
	Запись.Документ 		= Документ;
	Запись.ОписаниеОшибки 	= ОписаниеОшибки;
	
	Если Дата = Неопределено Тогда
		Запись.Дата = рмкОбщегоНазначенияПереопределяемый.ЗначениеРеквизитаОбъекта(Документ, "Дата");
	Иначе
		Запись.Дата = Дата;
	КонецЕсли;	
		
	ЗаписиРегистра.Записать();		
	
КонецПроцедуры	

Процедура ВыполнитьОтложенноеПроведение() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	рмкДокументыКОтложенномуПроведению.Документ
	|ИЗ
	|	РегистрСведений.рмкДокументыКОтложенномуПроведению КАК рмкДокументыКОтложенномуПроведению
	|
	|УПОРЯДОЧИТЬ ПО
	|	рмкДокументыКОтложенномуПроведению.Дата,
	|	рмкДокументыКОтложенномуПроведению.Документ
	|АВТОУПОРЯДОЧИВАНИЕ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			ДокументОбъект = Выборка.Документ.ПолучитьОбъект();
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			УдалитьИзОчереди(Выборка.Документ);
			
		Исключение
			
			ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации("RMQ.Ошибка отложенного проведения", УровеньЖурналаРегистрации.Ошибка, , Выборка.Документ, ТекстОшибки);
			ДобавитьВОчередь(Выборка.Документ, Выборка.Дата, ТекстОшибки);
			
		КонецПопытки;		
		
	КонецЦикла;	
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьИзОчереди(Документ)
	
	ЗаписиРегистра = СоздатьНаборЗаписей();
	ЗаписиРегистра.Отбор.Документ.Установить(Документ);
	ЗаписиРегистра.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли