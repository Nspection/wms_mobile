
&НаКлиенте
Процедура НайтиДанные(Команда)
	Если Строка<>"" Тогда 
		ОповеститьОВыборе(новый Структура("Строка,ЭлементПоиска",Строка,ЭлементПоиска));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
	Элементы.ЭлементПоиска.СписокВыбора.Добавить("Документ");
	Элементы.ЭлементПоиска.СписокВыбора.Добавить("Задача");
	ЭлементПоиска="Задача";
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

