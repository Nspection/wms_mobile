
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
ОповеститьОВыборе(Комментарий);	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не Параметры.Свойство("ИдЗадачи") тогда
		Отказ=Истина;
		Возврат
	КонецЕсли;
	Если  не Параметры.Свойство("ОбъектДокумента") тогда
		Отказ=Истина;
		Возврат
	КонецЕсли;
ИдЗадачи=Параметры.ИдЗадачи;
ОбъектДокумента=Параметры.ОбъектДокумента;
ЗаполнитьЗначенияКомментарияЗадачи();	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияКомментарияЗадачи()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИтЗадачиНаТСД.ДополнительныеДанные КАК ДополнительныеДанные
		|ИЗ
		|	РегистрСведений.ИтЗадачиНаТСД КАК ИтЗадачиНаТСД
		|ГДЕ
		|	ИтЗадачиНаТСД.ДокументОснование = &ДокументОснование
		|	И ИтЗадачиНаТСД.ИдЗадачи = &ИдЗадачи";
	
	Запрос.УстановитьПараметр("ДокументОснование", ОбъектДокумента);
	Запрос.УстановитьПараметр("ИдЗадачи", ИдЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДополнительныеДанные=ВыборкаДетальныеЗаписи.ДополнительныеДанные.Получить();
		Если ТипЗнч(ДополнительныеДанные)=Тип("Структура") тогда
			Если ДополнительныеДанные.Свойство("Комментарий") тогда
				Комментарий=ДополнительныеДанные.Комментарий;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
	
	КонецПроцедуры
