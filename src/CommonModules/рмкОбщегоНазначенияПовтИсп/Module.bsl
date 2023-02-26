
#Область ПрограммныйИнтерфейс

Функция МетаданныеДоступныеДляРепликации() Экспорт
	
	МассивИменМетаданных = Новый Массив;
	
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.Справочники, 		МассивИменМетаданных);
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.Документы, 		МассивИменМетаданных);
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.ПланыВидовХарактеристик, МассивИменМетаданных);
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.ПланыВидовРасчета, МассивИменМетаданных);
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.ПланыСчетов, 		МассивИменМетаданных);
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.РегистрыСведений, 	МассивИменМетаданных);
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.РегистрыНакопления,МассивИменМетаданных);  
	
	Для Каждого МетаданныеИсключения Из Метаданные.Подсистемы.рмкRMQConnector.Состав Цикл
		
		ИндексЭлемента = МассивИменМетаданных.Найти(МетаданныеИсключения.ПолноеИмя());
		
		Если ИндексЭлемента <> Неопределено Тогда
			МассивИменМетаданных.Удалить(ИндексЭлемента);
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат МассивИменМетаданных;
	
КонецФункции

Функция ПолучитьДоступныеВерсииКомпонентыRQM() Экспорт
	
	ИменаМакетов = Новый Массив;
	
	Для Каждого ЭлементМетаданных Из Метаданные.Подсистемы.рмкRMQConnector.Состав Цикл
		
		Если Метаданные.ОбщиеМакеты.Содержит(ЭлементМетаданных) И СтрНайти(ЭлементМетаданных.Имя, "PinkRabbitMQ") Тогда
			ИменаМакетов.Добавить(ЭлементМетаданных.Имя);
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат ИменаМакетов;
	
КонецФункции	

Функция ПолучитьВерсиюКомпонентыRQM() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ВерсияКомпоненты = Константы.рмкВерсияКомпоненты.Получить();
	
	Если ПустаяСтрока(ВерсияКомпоненты) Тогда
		
		ВерсииКомпоненты = ПолучитьДоступныеВерсииКомпонентыRQM();
		ВерсияКомпоненты = ВерсииКомпоненты[0];
		
	КонецЕсли;	
	
	Возврат ВерсияКомпоненты;	
	
КонецФункции

Функция ТочкаПодключенияПоИмени(ИмяТочки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Справочники.рмкТочкиПодключения.НайтиПоРеквизиту("ИмяДляРазработчика", ИмяТочки);
	
КонецФункции	

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьИменаМетаданныхКоллекцииВМассиве(КоллекцияМетаданных, МассивИменМетаданных)
	
	Для Каждого МетаданныеОбъекта Из КоллекцияМетаданных Цикл
		МассивИменМетаданных.Добавить(МетаданныеОбъекта.ПолноеИмя());
	КонецЦикла;
	
КонецПроцедуры		

#КонецОбласти
