#Область ОбработчикиСобытий
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не Параметры.Свойство("МассивДанных") Тогда 
		Отказ=Истина;
		Возврат
	КонецЕсли;	
	Если не Параметры.Свойство("СкладИдентификатора") Тогда 
		Отказ=Истина;
		Возврат
	КонецЕсли;
	Если не Параметры.Свойство("СкладИдентификатораПредставление") Тогда 
		Отказ=Истина;
		Возврат
	КонецЕсли;
	Если не Параметры.Свойство("ИдентификаторУпаковки") Тогда 
		Отказ=Истина;
		Возврат
	КонецЕсли;
	ИдентификаторУпаковки=Параметры.ИдентификаторУпаковки;
	ИдентификаторУпаковкиПолучатель= Параметры.ИдентификаторУпаковки;
	СкладДвижения=Параметры.СкладИдентификатора;
	СкладДвиженияПредставление=Параметры.СкладИдентификатораПредставление;
	Для Каждого стр из Параметры.МассивДанных цикл
		НоваяСтрока=СоставПаллеты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,стр);
		НоваяСтрока.КоличествоМаксимум=стр.Количество;
		НоваяСтрока.ИдентификаторУпаковкиПолучатель=ИдентификаторУпаковки;
		НоваяСтрока.ИдентификаторУпаковки=ИдентификаторУпаковки;
		НоваяСтрока.ИдентификаторСтроки=новый УникальныйИдентификатор();
    КонецЦикла;
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
Процедура СоставПаллетыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	ОткрытьФорму("Документ.итРучноеПеремещение.Форма.ФормаИзмененияСтроки",новый Структура("ИдентификаторСтроки,Количество,КоличествоМаксимум,Номенклатура,НоменклатураПредставление,СерияНоменклатуры,СерияНоменклатурыПредставление",
	ТекущийЭлемент.ТекущиеДанные.ИдентификаторСтроки,ТекущийЭлемент.ТекущиеДанные.Количество,ТекущийЭлемент.ТекущиеДанные.КоличествоМаксимум,ТекущийЭлемент.ТекущиеДанные.Номенклатура,
	ТекущийЭлемент.ТекущиеДанные.НоменклатураПредставление,ТекущийЭлемент.ТекущиеДанные.СерияНоменклатуры,ТекущийЭлемент.ТекущиеДанные.СерияНоменклатурыПредставление),ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы="Документ.итРучноеПеремещение.Форма.ФормаИзмененияСтроки" Тогда 
		 ИзменитьДанныеПаллетыНаСервере(ВыбранноеЗначение)
	 КонецЕсли;
	 Если ИсточникВыбора.ИмяФормы= "ОбщаяФорма.СканированиеЯчейки" тогда
		 УстановитьЯчейкуПолучатель(ВыбранноеЗначение);
     КонецЕсли;
	КонецПроцедуры

#КонецОбласти



#Область ОбработчикиКоманд
&НаКлиенте
Процедура Назад(Команда)
ЭтаФорма.Закрыть();	
КонецПроцедуры
&НаКлиенте
Процедура Добавить(Команда)
Если ЯчейкаПолучатель=СлужебныеФункцииИПроцедурыКлиентСервер.ПустойУникальныйИдентификатор() Тогда 
	Сообщить("Укажите ячейку получатель");
	Возврат;
КонецЕсли;	
МассивДанных=ТаблицуВМассив();
ОповеститьОВыборе(новый Структура("СкладДвижения,СкладДвиженияПредставление,МассивДанных",СкладДвижения,СкладДвиженияПредставление,МассивДанных));
КонецПроцедуры
&НаКлиенте
Процедура ЯчейкаПолучательПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	ОткрытьФорму("ОбщаяФорма.СканированиеЯчейки",Новый Структура("ПолеПолучательИдентификатор,ПолеПолучательПредставление","ЯчейкаПолучатель","ЯчейкаПолучательПредставление"),ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

#КонецОбласти



#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ИзменитьДанныеПаллетыНаСервере(СтруктураДанных)
	Строки=СоставПаллеты.НайтиСтроки(новый Структура("ИдентификаторСтроки",СтруктураДанных.ИдентификаторСтроки));
	Для Каждого Стр из Строки цикл
		Стр.Количество=СтруктураДанных.Количество;
		КонецЦикла;
	КонецПроцедуры
&НаСервере
Функция ТаблицуВМассив()
МассивДанных=Новый Массив;
Для Каждого стр из СоставПаллеты цикл
СтруктураДанных=новый Структура;
СтруктураДанных.Вставить("Номенклатура",стр.Номенклатура);
СтруктураДанных.Вставить("НоменклатураПредставление",стр.НоменклатураПредставление);
СтруктураДанных.Вставить("СерияНоменклатуры",стр.СерияНоменклатуры);
СтруктураДанных.Вставить("СерияНоменклатурыПредставление",стр.СерияНоменклатурыПредставление);
СтруктураДанных.Вставить("ДатаРозлива",стр.ДатаРозлива);
СтруктураДанных.Вставить("Количество",стр.Количество);
СтруктураДанных.Вставить("Качество",стр.Качество);
СтруктураДанных.Вставить("ЯчейкаОтправитель",стр.ЯчейкаОтправитель);
СтруктураДанных.Вставить("ЯчейкаОтправительПредставление",стр.ЯчейкаОтправительПредставление);
СтруктураДанных.Вставить("ЯчейкаПолучатель",стр.ЯчейкаПолучатель);
СтруктураДанных.Вставить("ЯчейкаПолучательПредставление",стр.ЯчейкаПолучательПредставление);
СтруктураДанных.Вставить("ЯчейкаПолучатель",стр.ЯчейкаПолучатель);
СтруктураДанных.Вставить("ИдентификаторУпаковки",стр.ИдентификаторУпаковки);
СтруктураДанных.Вставить("ИдентификаторУпаковкиПолучатель",стр.ИдентификаторУпаковкиПолучатель);
МассивДанных.Добавить(СтруктураДанных);
КонецЦикла;
Возврат МассивДанных;	
КонецФункции

&НаСервере
Процедура УстановитьЯчейкуПолучатель(СтруктураДанных)
	ЯчейкаПолучатель=СтруктураДанных.Ячейка;
	ЯчейкаПолучательПредставление=СтруктураДанных.ЯчейкаПредставление;
	Для Каждого стр из СоставПаллеты цикл
		стр.ЯчейкаПолучатель=ЯчейкаПолучатель;
		стр.ЯчейкаПолучательПредставление=ЯчейкаПолучательПредставление;
		КонецЦикла;
КонецПроцедуры

#КонецОбласти