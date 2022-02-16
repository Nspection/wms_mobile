
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.НоменклатураПредставление.Видимость=Ложь;
    Элементы.ДатаРозлива.Видимость=Ложь;
    Элементы.КоличествоПлан.Видимость=Ложь;
    Элементы.КоличествоФакт.Видимость=Ложь;
    Элементы.SSCC.Видимость=Ложь;
	Элементы.СерияНоменклатурыПредставление.Видимость=Ложь;
	
	
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
	Если Параметры.Свойство("СерияНоменклатурыПредставление") тогда
		СерияНоменклатурыПредставление=Параметры.СерияНоменклатурыПредставление;
		Элементы.СерияНоменклатурыПредставление.Видимость=Истина;

	КонецЕсли;

	
	Если Параметры.Свойство("КоличествоПлан") тогда
		КоличествоПлан=Параметры.КоличествоПлан;
		Элементы.КоличествоПлан.Видимость=Истина;

	КонецЕсли;

	Если Параметры.Свойство("КоличествоФакт") тогда
		КоличествоФакт=Параметры.КоличествоФакт;
		Элементы.КоличествоФакт.Видимость=Истина;

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
