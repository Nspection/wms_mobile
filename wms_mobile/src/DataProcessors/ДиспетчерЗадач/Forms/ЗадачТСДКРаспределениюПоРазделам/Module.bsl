
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Наборки(Команда)
	ОткрытьФорму("Документ.итНаборка.Форма.ФормаНаборокКРаспределениюПоМаршрутам",,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВсеЗадачи(Команда)
	ОткрытьФорму("Обработка.ДиспетчерЗадач.Форма.ЗадачиКРаспределениюДерево",,ЭтаФорма);
КонецПроцедуры
