#Область ПрограммныйИнтерфейс
	
Функция ЗначениеРеквизитаОбъекта(Объект, ИмяРеквизита) Экспорт

	// в конфигурации на БСП заменить на вызов метода "ОбщегоНазначения.ЗначениеРеквизитаОбъекта"	
	Возврат Объект[ИмяРеквизита];
	
КонецФункции	

Функция ЗначенияРеквизитовОбъектов(Объект, ИменаРеквизитов) Экспорт

	// в конфигурации на БСП заменить на вызов метода "ОбщегоНазначения.ЗначениеРеквизитаОбъекта"	
	ЗначенияРеквизитов = Новый Структура(ИменаРеквизитов);
	
	Для Каждого КлючИЗначение Из ЗначенияРеквизитов Цикл
		ЗначенияРеквизитов.Вставить(КлючИЗначение.Ключ, Объект[КлючИЗначение.Ключ]);
	КонецЦикла; 
	
	Возврат ЗначенияРеквизитов;
	
КонецФункции

#КонецОбласти