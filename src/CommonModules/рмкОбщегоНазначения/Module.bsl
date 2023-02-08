#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиРегламентныхЗаданий

Процедура ВыполнитьОтложенноеПроведениеДокументов() Экспорт
 	
 	РегистрыСведений.рмкДокументыКОтложенномуПроведению.ВыполнитьОтложенноеПроведение();
 	
КонецПроцедуры

#КонецОбласти

#Область Сериализация

Функция СериализоватьОбъект(ОбъектДляСериализации) Экспорт
	
	// пока только JSON, потом, возможно, будет больше
	Возврат ЗаписатьОбъектВJSON(ОбъектДляСериализации);
	
КонецФункции

Функция ДесериализоватьОбъект(Данные) Экспорт
	
	// пока только JSON, потом, возможно, будет больше
	Возврат ПрочитатьОбъектИзJSON(Данные);
	
КонецФункции	

#КонецОбласти 

Функция ПодключаемыйМенеджерКонвертацииЗагружен() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.рмкХранилищеПодключаемогоМенеджераКонвертации.Получить().Получить() <> Неопределено;
	
КонецФункции

Функция СсылкаПоУникальномуИдентификатору(ИмяМетаданных, УИДСтрокой) Экспорт
	
	Перем МенеджерОбъекта;
	
	УстановитьПривилегированныйРежим(Истина);
	Выполнить("МенеджерОбъекта = " + ИмяМетаданных);
	УИД = Новый УникальныйИдентификатор(УИДСтрокой);
		
	Возврат МенеджерОбъекта.ПолучитьСсылку(УИД);
	
КонецФункции

Функция ЭтоДокумент(Объект) Экспорт
	
	Возврат Метаданные.Документы.Содержит(Объект.Метаданные());
	
КонецФункции

// TODO вынести в модуль повторного использования
// TODO убрать элементы подсистемы RMQConnector из списка
Функция МетаданныеДоступныеДляРепликации() Экспорт
	
	МассивИменМетаданных = Новый Массив;
	
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.Справочники, 		МассивИменМетаданных);
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.Документы, 		МассивИменМетаданных);
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.ПланыВидовХарактеристик, МассивИменМетаданных);
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.ПланыВидовРасчета, МассивИменМетаданных);
	ЗаполнитьИменаМетаданныхКоллекцииВМассиве(Метаданные.ПланыСчетов, 		МассивИменМетаданных);
	
	// отдельно добавим только независимые регистры сведений
	Для Каждого МетаданныеОбъекта Из Метаданные.РегистрыСведений Цикл
		
		Если ЭтоНезависимыйРегистрСведений(МетаданныеОбъекта) Тогда
			МассивИменМетаданных.Добавить(МетаданныеОбъекта.ПолноеИмя());
		КонецЕсли;	
		
	КонецЦикла;
	
	Возврат МассивИменМетаданных;
	
КонецФункции

Функция ЭтоНезависимыйРегистрСведений(МетаданныеОбъекта) Экспорт
	
	Возврат Метаданные.РегистрыСведений.Содержит(МетаданныеОбъекта) 
			И МетаданныеОбъекта.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаписатьОбъектВJSON(ОбъектДляСериализации)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	
	Если ОбъектДляСериализации.Свойство("SerializationMetod") 
			И ОбъектДляСериализации.SerializationMetod = "SerializationMetod_1CXDTO"	Тогда
	
  		СериализаторXDTO.ЗаписатьJSON(ЗаписьJSON, ОбъектДляСериализации);
  	
	Иначе
		
		ЗаписатьJSON(ЗаписьJSON, ОбъектДляСериализации);
		
	КонецЕсли;	
  		
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

Функция ПрочитатьОбъектИзJSON(СтрокаJSON)
	
	ЧтениеJSON = Новый ЧтениеJSON;
  	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
  	
  	Если ЭтоФорматXTDO(СтрокаJSON) Тогда 
  		Результат = СериализаторXDTO.ПрочитатьJSON(ЧтениеJSON, Тип("Структура"));
  	Иначе	  	
  		Результат = ПрочитатьJSON(ЧтениеJSON, Ложь);
  	КонецЕсли;
  	
  	ЧтениеJSON.Закрыть();
    
  	Возврат Результат;
	
КонецФункции

// TODO способ определения формата нуждается в рефакторинге, так как очень неточен
Функция ЭтоФорматXTDO(СтрокаJSON)
	
	Возврат СтрНайти(СтрокаJSON, "SerializationMetod_1CXDTO") > 0;
	
КонецФункции

Процедура ЗаполнитьИменаМетаданныхКоллекцииВМассиве(КоллекцияМетаданных, МассивИменМетаданных)
	
	Для Каждого МетаданныеОбъекта Из КоллекцияМетаданных Цикл
		МассивИменМетаданных.Добавить(МетаданныеОбъекта.ПолноеИмя());
	КонецЦикла;
	
КонецПроцедуры		

#КонецОбласти


