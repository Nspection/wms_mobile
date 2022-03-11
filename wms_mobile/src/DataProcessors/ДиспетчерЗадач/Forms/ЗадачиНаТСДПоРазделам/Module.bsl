
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
	Если Параметры.ТипРаздела="Наборки" Тогда
		ПодключитьОбработчикОжидания("ОткрытиеФормыНаборокПослеОжидания",1,Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытиеФормыНаборокПослеОжидания()Экспорт 
	Наборки("");
	КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Наборки(Команда)
	ОткрытьФорму("Документ.итНаборка.Форма.МоиЗадачиМаршрут",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВсеЗадачи(Команда)
	ОткрытьФорму("Обработка.ДиспетчерЗадач.Форма.МоиЗадачиОбщийСписок",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры
