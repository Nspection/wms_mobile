
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.НоменклатураПредставление.Видимость=Ложь;
    Элементы.ДатаРозлива.Видимость=Ложь;
    Элементы.Количество.Видимость=Ложь;
	//Элементы.КоличествоФакт.Видимость=Ложь;
    Элементы.SSCC.Видимость=Ложь;
    Элементы.КачествоПредставление.Видимость=Ложь;
	Элементы.СерияНоменклатурыПредставление.Видимость=Ложь;
    Элементы.ЯчейкаПредставление.Видимость=Ложь;

	
	
	Если Параметры.Свойство("ИдентификаторУпаковки") тогда
		SSCC=Параметры.ИдентификаторУпаковки;
		Элементы.SSCC.Видимость=Истина;
	КонецЕсли;

	Если Параметры.Свойство("НоменклатураПредставление") тогда
		НоменклатураПредставление=Параметры.НоменклатураПредставление;
		Элементы.НоменклатураПредставление.Видимость=Истина;
	КонецЕсли;
	Если Параметры.Свойство("ДатаРозлива") тогда
		ДатаРозлива=Параметры.ДатаРозлива;
		Элементы.ДатаРозлива.Видимость=Истина;

	КонецЕсли;

	Если Параметры.Свойство("Количество") тогда
		Количество=Параметры.Количество;
		Элементы.Количество.Видимость=Истина;

	КонецЕсли;
	Если Параметры.Свойство("КачествоПредставление") тогда
		КачествоПредставление=Параметры.КачествоПредставление;
		Элементы.КачествоПредставление.Видимость=Истина;

	КонецЕсли;
	//Если Параметры.Свойство("СерияНоменклатурыПредставление") тогда
	//	СерияНоменклатурыПредставление=Параметры.СерияНоменклатурыПредставление;
	//	Элементы.СерияНоменклатурыПредставление.Видимость=Истина;

	//КонецЕсли;
	Если Параметры.Свойство("ЯчейкаПредставление") тогда
		ЯчейкаПредставление=Параметры.ЯчейкаПредставление;
		Элементы.ЯчейкаПредставление.Видимость=Истина;
	КонецЕсли;




	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры
