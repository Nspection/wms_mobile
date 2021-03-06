
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ШтрихКодЯчейкиДокумента") и Параметры.Свойство("ДокументЗадачИнвентаризации") тогда
		ДокументЗадачи=Параметры.ДокументЗадачИнвентаризации;
		ЗаполнитьДаннымиПоДокументу(Отказ,Параметры.ШтрихКодЯчейкиДокумента);
	КонецЕсли;
	КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);	
	ВидимостьИДоступностьЭлементовСервер();
КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ОбработчикШтрихКода"  и ТригерПриемаСканераШтрихКода тогда
		Если Параметр=404 и Источник="ОшибкаЧтения" тогда
			ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Штрих код некорректен");
			Возврат
		КонецЕсли;	
		ОбработатьДанныеШтрихКода(Параметр)
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура СоставЯчейкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	ОткрытьФорму("Обработка.ОбработчикИнвентаризацииЯчейки.Форма.ФормаПросмотраСтрокиНМ",новый Структура("НоменклатураПредставление,"
	+"ДатаРозлива,КоличествоПлан,КоличествоФакт,ИдентификаторУпаковки",ТекущийЭлемент.ТекущиеДанные.НоменклатураПредставление,
	ТекущийЭлемент.ТекущиеДанные.ДатаРозлива,ТекущийЭлемент.ТекущиеДанные.Количество,ТекущийЭлемент.ТекущиеДанные.КоличествоФакт,
	ТекущийЭлемент.ТекущиеДанные.ИдентификаторУпаковки),ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;

КонецПроцедуры
&НаКлиенте
Процедура СоставЯчейкиБезУчетаSSCCВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	ОткрытьФорму("Обработка.ОбработчикИнвентаризацииЯчейки.Форма.ФормаПросмотраСтрокиНМ",новый Структура("НоменклатураПредставление,"
	+"ДатаРозлива,КоличествоПлан,КоличествоФакт",ТекущийЭлемент.ТекущиеДанные.НоменклатураПредставление,
	ТекущийЭлемент.ТекущиеДанные.ДатаРозлива,ТекущийЭлемент.ТекущиеДанные.Количество,ТекущийЭлемент.ТекущиеДанные.КоличествоФакт),ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ВидЯчеечногоУчетаПриИзменении(Элемент)
ВидимостьИДоступностьЭлементовКлиент();
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКоманд
&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры
&НаКлиенте
Процедура Добавить(Команда)
	ОткрытьФорму("Обработка.ОбработчикИнвентаризацииЯчейки.Форма.ФормаДобавленияНового",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры
&НаКлиенте
Процедура ЗавершитьИнвентаризациюЯчейки(Команда)
	Отказ=Ложь;
	ЗавершитьИнвентаризациюЯчейкиНаСервере(Отказ);
	Если не Отказ тогда
		ЭтаФорма.Закрыть();
		ОбщийМодульКлиентскойЧасти.ОповещениеДинамическихСписковОткрытыхФорм();
	КонецЕсли;	
КонецПроцедуры
&НаСервере
Процедура ЗавершитьИнвентаризациюЯчейкиНаСервере(Отказ)
ТаблицаСоставаЯчейки=СоставЯчейки.Выгрузить();
ТаблицаСоставаЯчейки.Свернуть("Номенклатура,НоменклатураПредставление,ДатаРозлива,ИдентификаторУпаковки","Количество,КоличествоФакт");
СтруктураДанных=новый Структура("ТипОбработкиДанных,ТаблицаСоставаЯчейки,КлючПолученияДанных","ФиксацияДанныхИнвентаризации",ТаблицаСоставаЯчейки,Ячейка);
СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
Если ИдЗадачи<> новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") тогда
	СтруктураДанных.Вставить("КлючИнициализацииДанных",ИдЗадачи);
	СтруктураДанных.Вставить("ТипЗадачи",Перечисления.итWMSТипыЗадачТСД.Инвентаризация);
	СтруктураДанных.Вставить("ТипИнициализации","Задача");
	СтруктураДанных.Вставить("СостояниеИнициализации",Перечисления.итWMSСостоянияЗадачТСД.Выполнена);
	СтруктураДанных.Вставить("ФиксацияЗадачи",Истина);
КонецЕсли;
СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"Inventory");
Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураДанных,"Инициализация") Тогда
	Отказ=Истина;
	Возврат
КонецЕсли;
Если  ИдЗадачи<> новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") тогда
	МодульРаспределенияДанных.ОбработчикВходящихДанных(СтруктураДанных);
КонецЕсли;


	КонецПроцедуры
#КонецОбласти
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьДанныеШтрихКода(Параметр)
	Если Элементы.ЭтапСканирования.Заголовок="Сканируйте ячейку" тогда
		ОбработчикСканированияЯчейки(Параметр);
	иначе
		ОбработчикСканированияSSCC(Параметр);
	КонецЕсли;
	ВидимостьИДоступностьЭлементовКлиент();
КонецПроцедуры
&НаКлиенте
Процедура ОбработчикСканированияSSCC(Параметр)
	МассивСтрок=СоставЯчейки.НайтиСтроки(новый Структура("ИдентификаторУпаковки",СокрЛП(Параметр)));
	Если МассивСтрок.Количество()>0 тогда
		ОткрытьФорму("Обработка.ОбработчикИнвентаризацииЯчейки.Форма.ФормаИзмененияСущестующегоSSCC",новый Структура("SSCC",Параметр),ЭтаФорма);
		ТригерПриемаСканераШтрихКода=Ложь;
	иначе
		Сообщить("Такого SSCC нет по базе данных в ячейке");
	КонецЕсли;
	КонецПроцедуры
&НаКлиенте
Процедура ОбработчикСканированияЯчейки(Параметр)
	ЭтапСканированияЯчейки=ЭтапСканированияЯчейки+1;
	Если НайтиЯчейкуНаСервере(Параметр,,Ложь) тогда
		Если ЯчейкаСканированияВОбработке Тогда 
			ЯчейкаСканированияВОбработке=Ложь;
			Возврат;
		КонецЕсли;	
		Элементы.ЭтапСканирования.Заголовок="Сканируйте SSCC в ячейке";
		ЭтапСканированияЯчейки=0;
		НакопительСканированияЯчейки="";
	ИначеЕсли ШтрихКодНакопленВерно(Параметр)  тогда
		Если ЯчейкаСканированияВОбработке Тогда 
			ЯчейкаСканированияВОбработке=Ложь;
			Возврат;
		КонецЕсли;
			Элементы.ЭтапСканирования.Заголовок="Сканируйте SSCC в ячейке";
			ЭтапСканированияЯчейки=0;
			НакопительСканированияЯчейки="";
	ИначеЕсли  Элементы.ЭтапСканирования.Заголовок="Сканируйте ячейку" и ЭтапСканированияЯчейки<2 тогда
		НакопительСканированияЯчейки=СокрЛП(Параметр);
	иначе	
	    ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Отсканированный штрих-код "+Параметр+СокрЛП(НакопительСканированияЯчейки)+" не удовлетворяет требованиям");
		ЭтапСканированияЯчейки=0;
		НакопительСканированияЯчейки="";
	КонецЕсли;   	
КонецПроцедуры
&НаКлиенте
Функция ШтрихКодНакопленВерно(Параметр)
МассивШтрихКодаЯчейки=новый Массив;
МассивШтрихКодаЯчейки.Добавить(Врег(СокрЛП(НакопительСканированияЯчейки)+СокрЛП(Параметр)));
МассивШтрихКодаЯчейки.Добавить(Врег(СокрЛП(НакопительСканированияЯчейки)+"-"+СокрЛП(Параметр)));
МассивШтрихКодаЯчейки.Добавить(Врег(СокрЛП(Параметр)+"-"+СокрЛП(НакопительСканированияЯчейки)));
МассивШтрихКодаЯчейки.Добавить(Врег(СокрЛП(Параметр)+СокрЛП(НакопительСканированияЯчейки)));
Если ЭтапСканированияЯчейки=2 тогда
	СообщатьОбошибке=Истина;
иначе
	СообщатьОбошибке=Ложь;
КонецЕсли;
Возврат НайтиЯчейкуНаСервере(,МассивШтрихКодаЯчейки,СообщатьОбошибке); 
КонецФункции
&НаСервере
Функция НайтиЯчейкуНаСервере(ШтрихКодЯчейки="",МассивШтрихКодаЯчейки=Неопределено,СообщатьОбОшибке=Истина)
	Если ШтрихКодЯчейки="" и МассивШтрихКодаЯчейки = Неопределено тогда
		Возврат Ложь;
	КонецЕсли;
	Если МассивШтрихКодаЯчейки=Неопределено тогда
		МассивШтрихКодаЯчейки=новый Массив;
		МассивШтрихКодаЯчейки.Добавить(ВРег(СокрЛП(ШтрихКодЯчейки)));
	КонецЕсли;
СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(новый Структура("ТипОбработкиДанных,КлючПолученияДанных","ПолучениеДанныхЯчейки",МассивШтрихКодаЯчейки),"Inventory");
Если ТипЗнч(СтруктураДанных)=Тип("Структура")  тогда
	Если СтруктураДанных.Свойство("ОписаниеОшибки") Тогда 
		Если СтруктураДанных.ОписаниеОшибки="Ячейка находится в обработке" Тогда 
			Сообщить(СтруктураДанных.ОписаниеОшибки);
			ЭтапСканированияЯчейки=0;
			НакопительСканированияЯчейки="";
			ЯчейкаСканированияВОбработке=Истина;
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
КонецЕсли;	
Если  СообщатьОбОшибке тогда
	Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураДанных,"МассивДанных") тогда
		Возврат Ложь;
	КонецЕсли;
	Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураДанных,"Ячейка") тогда
		Возврат Ложь;
	КонецЕсли;
иначе
	Если СтруктураДанных.Свойство("Статус") тогда
		Если СтруктураДанных.Статус=404 тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;	
КонецЕсли;

Ячейка=СтруктураДанных.Ячейка;
ЯчейкаПредставление=СтруктураДанных.ЯчейкаПредставление;
СоставЯчейки.Очистить();
для Каждого стр из СтруктураДанных.МассивДанных цикл
	НоваяСтрока=СоставЯчейки.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока,стр);
	НоваяСтрока.ИдСтроки=новый УникальныйИдентификатор;
КонецЦикла;
ОбработкаСоставЯчейкиБезУчетаSSCC();
Возврат Истина;
КонецФункции
&НаКлиенте
Процедура ОбработкаСоставЯчейкиБезУчетаSSCCКлиент()Экспорт 
ОбработкаСоставЯчейкиБезУчетаSSCC();	
КонецПроцедуры
&НаСервере
Процедура ОбработкаСоставЯчейкиБезУчетаSSCC()
	СоставЯчейкиБезУчетаSSCC.Очистить();
	ТаблицаСоставЯчейкиБезУчетаSSCC=СоставЯчейкиБезУчетаSSCC.Выгрузить();
	для Каждого стр из СоставЯчейки цикл
		НоваяСтрока=ТаблицаСоставЯчейкиБезУчетаSSCC.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,стр);
	КонецЦикла;
	
	ТаблицаСоставЯчейкиБезУчетаSSCC.Свернуть("Номенклатура,НоменклатураПредставление,ДатаРозлива","Количество,КоличествоФакт");
	МассивСтрокКУдалению=новый Массив;
	Для Каждого Строка из ТаблицаСоставЯчейкиБезУчетаSSCC цикл
		Если Строка.Количество=0 и Строка.КоличествоФакт=0 тогда
			МассивСтрокКУдалению.Добавить(Строка);
		КонецЕсли;	
	КонецЦикла;
	Для Каждого СтрокаУдаления из МассивСтрокКУдалению цикл
		ТаблицаСоставЯчейкиБезУчетаSSCC.Удалить(СтрокаУдаления);
	КонецЦикла;
	СоставЯчейкиБезУчетаSSCC.Загрузить(ТаблицаСоставЯчейкиБезУчетаSSCC);
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьИДоступностьЭлементовКлиент()
	ВидимостьИДоступностьЭлементовСервер();
КонецПроцедуры
&НаСервере
Процедура ВидимостьИДоступностьЭлементовСервер()
	Если Элементы.ЭтапСканирования.Заголовок="Сканируйте ячейку" тогда
		Элементы.СоставЯчейкиДобавить.Видимость=Ложь;
	иначе
		Элементы.СоставЯчейкиДобавить.Видимость=Истина;
	КонецЕсли;
	 Элементы.СоставЯчейки.Видимость=не ВидЯчеечногоУчета; 
	 Элементы.СоставЯчейкиБезУчетаSSCC.Видимость=ВидЯчеечногоУчета; 
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиПоДокументу(Отказ,ШтрихКодЯчейкиДокумента)
	Если НайтиЯчейкуНаСервере(ШтрихКодЯчейкиДокумента) Тогда 
		Элементы.ЭтапСканирования.Заголовок="Сканируйте SSCC в ячейке";
		
		
		
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
		// Данный фрагмент построен конструктором.
		// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИтЗадачиНаТСД.ИдЗадачи КАК ИдЗадачи,
		|	ИтЗадачиНаТСД.ТипЗадачи КАК ТипЗадачи,
		|	ИтЗадачиНаТСД.Состояние КАК Состояние
		|ИЗ
		|	РегистрСведений.ИтЗадачиНаТСД КАК ИтЗадачиНаТСД
		|ГДЕ
		|	ИтЗадачиНаТСД.ДокументОснование = &ДокументОснование
		|	И ИтЗадачиНаТСД.ЯчейкаОтправитель = &ЯчейкаОтправитель";
		
		Запрос.УстановитьПараметр("ДокументОснование", ДокументЗадачи);
		Запрос.УстановитьПараметр("ЯчейкаОтправитель", Ячейка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если  ВыборкаДетальныеЗаписи.Следующий() Тогда 
			ИдЗадачи=ВыборкаДетальныеЗаписи.ИдЗадачи;
			СтруктураДанных=новый Структура;
			СтруктураДанных.Вставить("ИдЗадачи",ИдЗадачи);
			СтруктураДанных.Вставить("ТипЗадачи",ВыборкаДетальныеЗаписи.ТипЗадачи);
			СтруктураДанных.Вставить("Состояние",ВыборкаДетальныеЗаписи.Состояние);
			Если не  ОбработчикДанныхОбщиеФункцииИПроцедуры.ИнициализацияЗадачиНаСервере(СтруктураДанных,"Задача",Перечисления.итWMSСостоянияЗадачТСД.Выполняется) тогда
				Отказ=Истина;
				Сообщить("нет возможности инициализировать задачу ");
			КонецЕсли;
			
		иначе
			Отказ=Истина;
			Сообщить("нет данных ");	
		КонецЕсли;
		
	КонецЕсли;
	
	КонецПроцедуры


#КонецОбласти




