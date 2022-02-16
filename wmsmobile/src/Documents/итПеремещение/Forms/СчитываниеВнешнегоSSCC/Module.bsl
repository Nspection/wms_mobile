
#Область ОбработчикиСобытий
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.СсылкаНаОбъект.Пустая() тогда
		Отказ=Истина;
		Сообщить("Не верный формат данных");
	КонецЕсли;
	ОбъектДанных=Параметры.СсылкаНаОбъект;
	ТипЗадачи=ОбъектДанных.ТипЗадачи;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если не НеВозвращатьКонтрольНадТригером тогда
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ОбработчикШтрихКода"  и ТригерПриемаСканераШтрихКода тогда
		Если Параметр=404 и Источник="ОшибкаЧтения" тогда
			ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Штрих код некорректен");
			Возврат
		КонецЕсли;	
		СчитанныйSSCC=Параметр;
		ПрименитьКДокументу();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд
&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры
&НаКлиенте
Процедура ПрименитьКДокументу()
	//СлужебныеФункцииИПроцедурыКлиентСервер.ДобавитьВЛог(,"+#ПеремещениеСчитываниеВнешнего SSCC  ПрименитьКДокументу");
	Если ЗначениеЗаполнено(СчитанныйSSCC) тогда
		Отказ=Ложь;
		ОбщийМодульКлиентскойЧасти.ПроверитьSSCCНаЛеквидность(СчитанныйSSCC,Отказ);
		Если Отказ тогда
			Сообщить("текущий штрих код не соответствует нормам SSCC");
			Возврат
		КонецЕсли;	 	
		ОповеститьОВыборе(СчитанныйSSCC);
		//СлужебныеФункцииИПроцедурыКлиентСервер.ДобавитьВЛог(,"-#ПеремещениеСчитываниеВнешнего SSCC  ПрименитьКДокументу");
	иначе
		ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Вы не считали ни какого штрих-кода");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти