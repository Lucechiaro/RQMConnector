#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиРегламентныхЗаданий

Процедура ВыполнитьОтложенноеПроведениеДокументов() Экспорт
 	
 	РегистрыСведений.рмкДокументыКОтложенномуПроведению.ВыполнитьОтложенноеПроведение();
 	
КонецПроцедуры

Функция РазрешенаРаботаВКопииБазы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.рмкРазрешенаРаботаВКопииБазы.Получить();
	
КонецФункции	

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

Функция ПолучитьПредставлениеМетаданныхОбъекта(Объект) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(Объект));
	
	Если ОбъектМетаданных = Неопределено Тогда
		ПредставлениеМетаданных = "";
	Иначе
		ПредставлениеМетаданных = ОбъектМетаданных.ПолноеИмя();
	КонецЕсли;	
		
	Возврат ПредставлениеМетаданных;
	
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

#КонецОбласти