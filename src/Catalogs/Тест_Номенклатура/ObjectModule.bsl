#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;	
	
	ДополнительныеПараметры = Новый Структура("ЭтоНовый", Истина);
	рмкОбщегоНазначения.ЗаписатьВОчередьЛогов("Логи", "ЗаписьНоменклатуры", ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли