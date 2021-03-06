
#Область ОбработчикиСобытий
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если  не НеВозвращатьКонтрольНадТригером Тогда 
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
		 ОбработчкаПолученияДанныхШтрихКода(Параметр);
	 КонецЕсли;
 КонецПроцедуры
 &НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы="Документ.итРучноеПеремещение.Форма.ФормаОбработкиПаллеты" Тогда 
		ДобавитьДанныеСканирования(ВыбранноеЗначение);
		КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура ДанныеСканированияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		СтандартнаяОбработка=Ложь;
	ОткрытьФорму("Документ.итРучноеПеремещение.Форма.ФормаПросмотраСтрокиНМ",новый Структура("НоменклатураПредставление,Количество,ЯчейкаПредставление,ДатаРозлива,ИдентификаторУпаковки",ТекущийЭлемент.ТекущиеДанные.НоменклатураПредставление
	,ТекущийЭлемент.ТекущиеДанные.Количество,ТекущийЭлемент.ТекущиеДанные.ЯчейкаОтправительПредставление,ТекущийЭлемент.ТекущиеДанные.ДатаРозлива,ТекущийЭлемент.ТекущиеДанные.ИдентификаторУпаковки),ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;

КонецПроцедуры


#КонецОбласти



#Область ОбработчикиКоманд
&НаКлиенте
Процедура ОтказатьсяОтДокументаОповещение(Результат,Параметры)Экспорт
	Если Результат=КодВозвратаДиалога.Нет тогда
		Возврат
	КонецЕсли;
	ОтказатьсяОтДокументаНаСервере();
	ОбщийМодульКлиентскойЧасти.ОповещениеДинамическихСписковОткрытыхФорм();
	ОповеститьОВыборе(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтказатьсяОтДокумента(Команда)
	Оповещение = новый ОписаниеОповещения("ОтказатьсяОтДокументаОповещение",ЭтаФорма);
	ПоказатьВопрос(Оповещение,"Вы точно хотите удалить данные документа",РежимДиалогаВопрос.ДаНет);

КонецПроцедуры
&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПеремещение(Команда)
Оповещение=новый ОписаниеОповещения("ЗавершитьПеремещениеОповещение",ЭтаФорма);
ПоказатьВопрос(Оповещение," Вы точно хотите завершить перемещение ?",РежимДиалогаВопрос.ДаНет);
КонецПроцедуры
&НаКлиенте
Процедура ЗавершитьПеремещениеОповещение(Результат,Параметры) Экспорт 
	Если  Результат=КодВозвратаДиалога.Нет Тогда 
		Возврат
	КонецЕсли;
	Если ЗавершитьПеремещениеНаСервере() Тогда 
		ОтказатьсяОтДокументаНаСервере();
		ОповеститьОВыборе(Истина);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	ИдентификаторСтроки=ТекущийЭлемент.ТекущиеДанные.ПолучитьИдентификатор();
	УдалитьНаСервере(ИдентификаторСтроки);
КонецПроцедуры

#КонецОбласти



#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ОбработчкаПолученияДанныхШтрихКода(ШтрихКод)
Отказ=Ложь;
СлужебныеФункцииИПроцедурыКлиентСервер.ПроверитьSSCCНаЛеквидность(ШтрихКод,Отказ);
Если Отказ Тогда 
	Возврат
КонецЕсли;
ДанныеSSCC=ПолучитьДанныеSSCC(ШтрихКод);
Если ДанныеSSCC=Неопределено Тогда 
	Возврат
КонецЕсли;
Сообщение="";
АнализПолученныхДанныхSSCC(ДанныеSSCC,Сообщение);
ДанныеSSCC.Вставить("Сообщение",Сообщение);
Если ДанныеSSCC.МассивДанных.Количество()=0 Тогда
	Если  Сообщение<>"" Тогда 
		Сообщить(Сообщение);
		Возврат;
	иначе
		Сообщить("По данному SSCC  не найдено свободных остатков");
		Возврат;
	КонецЕсли;	
КонецЕсли;

ДанныеSSCC.Вставить("Объект",Объект.Ссылка);
ДанныеSSCC.Вставить("ИдентификаторУпаковки",ШтрихКод);
ОткрытьФорму("Документ.итРучноеПеремещение.Форма.ФормаОбработкиПаллеты",ДанныеSSCC,ЭтаФорма);
ТригерПриемаСканераШтрихКода=Ложь;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеSSCC(ШтрихКод)
СтруктураЗапросаДанных=новый Структура;
СтруктураЗапросаДанных.Вставить("ТипОбработкиДанных","ПоискДанныхПоSSCC");
СтруктураЗапросаДанных.Вставить("КлючИнициализацииДанных",ШтрихКод);
Если Объект.СкладДвижения<>СлужебныеФункцииИПроцедурыКлиентСервер.ПустойУникальныйИдентификатор() Тогда 
СтруктураЗапросаДанных.Вставить("Склад",Объект.СкладДвижения);
КонецЕсли;
СтруктураЗапросаДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураЗапросаДанных,"HandMove");
Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураЗапросаДанных,"МассивДанных") Тогда 
	Возврат Неопределено;
КонецЕсли;	
Возврат СтруктураЗапросаДанных;
КонецФункции

&НаСервере
Процедура АнализПолученныхДанныхSSCC(ДанныеSSCC,Сообщение)
	Индекс=0;
	Смещение=0;
	Для Каждого стр из  ДанныеSSCC.МассивДанных цикл
		ДанныеСтрокиСканирования=Объект.ДанныеСканирования.НайтиСтроки(новый Структура("Номенклатура,ИдентификаторУпаковки,ЯчейкаОтправитель,ДатаРозлива,СерияНоменклатуры,Качество",
		стр.Номенклатура,стр.ИдентификаторУпаковки,стр.ЯчейкаОтправитель,стр.ДатаРозлива,стр.СерияНоменклатуры,стр.Качество));
		Если ДанныеСтрокиСканирования.Количество()>0 Тогда 
			Для Каждого НайденнаяСтрока из ДанныеСтрокиСканирования цикл
				стр.Количество=стр.Количество-НайденнаяСтрока.Количество;
				Сообщение=Сообщение+"
				|из этого SSCC уже набранна номенклатура: "+НайденнаяСтрока.НоменклатураПредставление +" в количестве "+НайденнаяСтрока.Количество; 
			КонецЦикла;
		КонецЕсли;
		Если стр.Количество=0 Тогда 
			ДанныеSSCC.МассивДанных.Удалить(Индекс-Смещение);
			Смещение=Смещение+1;
		КонецЕсли;
		Индекс=Индекс+1;
	КонецЦикла;
	
	КонецПроцедуры
&НаСервере
Процедура ОтказатьсяОтДокументаНаСервере()
ОбъектДанных=Объект.Ссылка.ПолучитьОбъект();
ОбъектДанных.Удалить();
КонецПроцедуры

&НаСервере
Функция  ЗавершитьПеремещениеНаСервере()
СтруктураЗапросаДанных=новый Структура;
СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураЗапросаДанных);
СтруктураЗапросаДанных.Вставить("ТипОбработкиДанных","ЗавершениеПеремещения");
СтруктураЗапросаДанных.Вставить("КлючИнициализацииДанных",новый Структура("ДатаПеремещения,НомерПеремещения,Перемещение,Склад",Объект.ДатаПеремещения,Объект.НомерПеремещения,Объект.Перемещение,Объект.СкладДвижения));
СтруктураЗапросаДанных.Вставить("Данные",Объект.ДанныеСканирования.Выгрузить());
СтруктураЗапросаДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураЗапросаДанных,"HandMove");
Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураЗапросаДанных,"СозданДокумент") Тогда 
	Возврат Ложь;
КонецЕсли;
Возврат Истина;
	КонецФункции

&НаСервере
Процедура УдалитьНаСервере(ИдентификаторСтроки)
	Строка=Объект.ДанныеСканирования.НайтиПоИдентификатору(ИдентификаторСтроки);
	Объект.ДанныеСканирования.Удалить(Строка);
	ЭтаФорма.Записать();
КонецПроцедуры

&НаСервере
Процедура ДобавитьДанныеСканирования(СтруктураДанных)
	Если Объект.СкладДвижения=СлужебныеФункцииИПроцедурыКлиентСервер.ПустойУникальныйИдентификатор() Тогда 
		Объект.СкладДвижения=СтруктураДанных.СкладДвижения;
		Объект.СкладДвиженияПредставление=СтруктураДанных.СкладДвиженияПредставление;
	КонецЕсли;
	Для Каждого СтрокаДобавления из СтруктураДанных.МассивДанных цикл
		Строки=Объект.ДанныеСканирования.НайтиСтроки(новый Структура("Номенклатура,СерияНоменклатуры,ЯчейкаОтправитель,ИдентификаторУпаковки,Качество",
		СтрокаДобавления.Номенклатура,СтрокаДобавления.СерияНоменклатуры,СтрокаДобавления.ЯчейкаОтправитель,СтрокаДобавления.ИдентификаторУпаковки,СтрокаДобавления.Качество));
		Если Строки.Количество()=0 тогда
			НоваяСтрока=Объект.ДанныеСканирования.Добавить();
			НоваяСтрока.ИдентификаторСтроки=новый УникальныйИдентификатор();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаДобавления);
		иначе
			Строки[0].Количество=Строки[0].Количество+СтрокаДобавления.Количество;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


#КонецОбласти