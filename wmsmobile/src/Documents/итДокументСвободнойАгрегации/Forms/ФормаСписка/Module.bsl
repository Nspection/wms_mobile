
&НаСервере
Функция ДобавитьНаСервере()
	НовыйДокумент=Документы.итДокументСвободнойАгрегации.СоздатьДокумент();
	НовыйДокумент.Дата=ТекущаяДата();
	НовыйДокумент.Записать();
	Возврат НовыйДокумент.Ссылка;
КонецФункции

&НаКлиенте
Процедура Добавить(Команда)
	Ссылка=ДобавитьНаСервере();
	ОткрытьФорму("Документ.итДокументСвободнойАгрегации.Форма.ФормаДокумента",новый Структура("Ключ",Ссылка),ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
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
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
СтандартнаяОбработка=Ложь;
ОткрытьФорму("Документ.итДокументСвободнойАгрегации.Форма.ФормаДокумента",новый Структура("Ключ",ТекущийЭлемент.ТекущиеДанные.Ссылка),ЭтаФорма);
ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	 Если ИмяСобытия="ОбновлениеДанныхДинамическихСписков" и Источник=ОбщийМодульКлиентскойЧасти тогда
		Элементы.Список.Обновить();
	 КонецЕсли;
КонецПроцедуры
