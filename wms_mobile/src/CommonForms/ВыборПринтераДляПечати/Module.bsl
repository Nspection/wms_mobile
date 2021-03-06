
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
	ТекущийПринтерПредставление=СлужебныеФункцииИПроцедурыКлиентСервер.ПараметрыСеансаОтветСервера("Принтер");
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ОбработчикШтрихКода"  и ТригерПриемаСканераШтрихКода тогда
		Если Параметр=404 и Источник="ОшибкаЧтения" тогда
			ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Штрих код некорректен");
			Возврат
		КонецЕсли;	
		УстановитьПринтерДляПечатиПоШтрихКоду(Параметр);

	 КонецЕсли;

КонецПроцедуры
&НаСервере
Процедура УстановитьПринтерДляПечатиПоШтрихКоду(ШтрихКод)
	СтруктураДанных=новый Структура;
	СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
	СтруктураДанных.Вставить("КлючОперации","ПринтерПоШтрихКоду");
	СтруктураДанных.Вставить("Данные",НРег(ШтрихКод));
	СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"ServiceFunction");
	Если 	СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураДанных,"ТекущийПринтерПредставление") тогда
		Возврат
	КонецЕсли;
	Если 	СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураДанных,"ТекущийПринтер") тогда
		Возврат
	КонецЕсли;
	ТекущийПринтер=СтруктураДанных.ТекущийПринтер;
	ТекущийПринтерПредставление=СтруктураДанных.ТекущийПринтерПредставление;
	КонецПроцедуры
&НаСервере
Процедура ПечатьНаСервере()
	СтруктураДанных=новый Структура;
	СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
	СтруктураДанных.Вставить("КлючОперации","ПечатьSSCC");
	СтруктураДанных.Вставить("Принтер",ТекущийПринтерПредставление);
	СтруктураДанных.Вставить("ИдентификаторУпаковки",Параметры.ИдентификаторУпаковки);
	СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"ServiceFunction");
	СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураДанных);
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	ПечатьНаСервере();
КонецПроцедуры
