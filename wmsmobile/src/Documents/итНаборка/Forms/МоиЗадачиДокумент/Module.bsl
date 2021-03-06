
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не Параметры.Свойство("Маршрут") Тогда 
		Отказ=Истина;
		Возврат
	КонецЕсли;
	СписокНаборок.Параметры.УстановитьЗначениеПараметра("Маршрут",Параметры.Маршрут);
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СписокНаборокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Строка=ТекущийЭлемент.ТекущиеДанные;
	ОткрытьФорму("Документ.итНаборка.Форма.ФормаДокумента",новый Структура("Ключ",Строка.Ссылка),ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры
