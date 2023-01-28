

Процедура ОчиститьУстаревшиеСообщения() Экспорт
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ОбработатьВходящиеСообщения() Экспорт
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ВыполнитьОтложенноеПроведениеДокументов() Экспорт
	// Вставить содержимое обработчика.
КонецПроцедуры

#Область Сериализация

Функция ЗаписатьОбъектВJSON(ОбъектДляСериализации)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	
	Если ОбъектДляСериализации.Свойство("SerializationMetod") 
			И ОбъектДляСериализации.SerializationMetod = "1CXDTO"	Тогда
	
  		СериализаторXDTO.ЗаписатьJSON(ЗаписьJSON, ОбъектДляСериализации);
  	
	Иначе
		
		ЗаписатьJSON(ЗаписьJSON, ОбъектДляСериализации);
		
	КонецЕсли;	
  		
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции	

Функция СериализоватьОбъект(ОбъектДляСериализации) Экспорт
	
	// пока только JSON, потом, возможно, будет больше
	Возврат ЗаписатьОбъектВJSON(ОбъектДляСериализации);
	
КонецФункции

Функция ДесериализоватьОбъект(Данные) Экспорт
	
	// пока только JSON, потом, возможно, будет больше
	Возврат ПрочитатьОбъектИзJSON(Данные);
	
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

// немного костыльный метод
Функция ЭтоФорматXTDO(СтрокаJSON)
	
	Возврат СтрНайти(СтрокаJSON, """SerializationMetod"": ""1CXDTO""") > 0;
	
КонецФункции

#КонецОбласти 

Функция ПодключаемыйМенеджерКонвертацииЗагружен() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.рмкХранилищеПодключаемогоМенеджераКонвертации.Получить().Получить() <> Неопределено;
	
КонецФункции