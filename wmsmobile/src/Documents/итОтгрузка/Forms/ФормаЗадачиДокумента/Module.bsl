#Область ОбработчикиСобытий
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не Параметры.Свойство("ИдЗадачи") тогда
		Возврат
	КонецЕсли;
	ИдЗадачи=Параметры.ИдЗадачи;
	ЗаполнитьЗначенияФормы();
	Если Параметры.Свойство("ОткрытиеСчитыванием") тогда
		Режим="РежимСканированиеПаллетыНачало";
		ИнициализацияЗадачиНаСервере(Режим);
		ЗаполнитьЗначенияФормы();
		ДоступностьВидимостьЭлементовСервер();;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
	ДоступностьВидимостьЭлементовКлиент();
КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если не НеВозвращатьКонтрольНадТригером Тогда 
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

#КонецОбласти

#Область ОбработчикиКоманд
&НаКлиенте
Процедура Назад(Команда)
ЭтаФорма.Закрыть();
КонецПроцедуры
&НаКлиенте
Процедура ОтказатьсяОтЗадачи(Команда)
	Оповещение=новый ОписаниеОповещения("ОтказатьсяОтЗадачиОповещение",ЭтаФорма);
	ПоказатьВопрос(Оповещение,"Вы точно хотите отказаться от Задачи",РежимДиалогаВопрос.ДаНет);
КонецПроцедуры
&НаКлиенте
Процедура ОтказатьсяОтЗадачиОповещение(Результат,Параметры) Экспорт 
	Если Результат=КодВозвратаДиалога.Нет тогда
		Возврат
	КонецЕсли;	
	Если ОтказатьсяОтЗадачиНаСервере() тогда
		ОбщийМодульКлиентскойЧасти.ОповещениеДинамическихСписковОткрытыхФорм();
		ЭтаФорма.Закрыть();
	иначе
		ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("не удачная попытка отказа от задачи, попробуйте еще раз, или подойтиде к оператору");
	КонецЕсли;	
КонецПроцедуры
&НаСервере
Функция ОтказатьсяОтЗадачиНаСервере()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	СтруктураОтказаЗадачи= ПолучитьДанныеДляИнициализации();
	Возврат ОбработчикДанныхОбщиеФункцииИПроцедуры.ИнициализацияЗадачиНаСервере(СтруктураОтказаЗадачи,"ЗадачаОтказ",Перечисления.итWMSСостоянияЗадачТСД.КВыполнению);
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ЗаполнитьЗначенияФормы()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИтЗадачиНаТСД.ИдентификаторУпаковки КАК ИдентификаторУпаковки,
		|	ИтЗадачиНаТСД.ЯчейкаОтправитель КАК ЯчейкаОтправитель,
		|	ИтЗадачиНаТСД.ЯчейкаОтправительПредставление КАК ЯчейкаОтправительПредставление,
		|	ИтЗадачиНаТСД.ЯчейкаПолучатель КАК ЯчейкаПолучатель,
		|	ИтЗадачиНаТСД.ЯчейкаПолучательПредставление КАК ЯчейкаПолучательПредставление,
		|	ИтЗадачиНаТСД.Состояние КАК Состояние,
		|	ИтЗадачиНаТСД.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ДанныеЗадачи
		|ИЗ
		|	РегистрСведений.ИтЗадачиНаТСД КАК ИтЗадачиНаТСД
		|ГДЕ
		|	ИтЗадачиНаТСД.ИдЗадачи = &ИдЗадачи
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеЗадачи.ИдентификаторУпаковки КАК ИдентификаторУпаковки,
		|	ДанныеЗадачи.ЯчейкаОтправитель КАК ЯчейкаОтправитель,
		|	ДанныеЗадачи.ЯчейкаОтправительПредставление КАК ЯчейкаОтправительПредставление,
		|	ДанныеЗадачи.ЯчейкаПолучатель КАК ЯчейкаПолучатель,
		|	ДанныеЗадачи.ЯчейкаПолучательПредставление КАК ЯчейкаПолучательПредставление,
		|	ДанныеЗадачи.Состояние КАК Состояние,
		|	МАКСИМУМ(итШтрихКодЯчеекДокументаОтправитель.ШтрихКод) КАК ШтрихКодЯчейкиОтправитель,
		|	МАКСИМУМ(ШтрихКодЯчеекДокументаПолучатель.ШтрихКод) КАК ШтрихКодЯчейкиПолучатель
		|ИЗ
		|	ДанныеЗадачи КАК ДанныеЗадачи
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.итОтгрузка.ШтрихКодыЯчеекДокумента КАК итШтрихКодЯчеекДокументаОтправитель
		|		ПО ДанныеЗадачи.ДокументОснование = итШтрихКодЯчеекДокументаОтправитель.Ссылка
		|			И ДанныеЗадачи.ЯчейкаОтправитель = итШтрихКодЯчеекДокументаОтправитель.Ячейка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.итОтгрузка.ШтрихКодыЯчеекДокумента КАК ШтрихКодЯчеекДокументаПолучатель
		|		ПО ДанныеЗадачи.ДокументОснование = ШтрихКодЯчеекДокументаПолучатель.Ссылка
		|			И ДанныеЗадачи.ЯчейкаПолучатель = ШтрихКодЯчеекДокументаПолучатель.Ячейка
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеЗадачи.ИдентификаторУпаковки,
		|	ДанныеЗадачи.ЯчейкаОтправитель,
		|	ДанныеЗадачи.ЯчейкаОтправительПредставление,
		|	ДанныеЗадачи.ЯчейкаПолучатель,
		|	ДанныеЗадачи.ЯчейкаПолучательПредставление,
		|	ДанныеЗадачи.Состояние";
	
	Запрос.УстановитьПараметр("ИдЗадачи", ИдЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ЭтаФорма,ВыборкаДетальныеЗаписи);
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецПроцедуры
&НаКлиенте
Процедура ДоступностьВидимостьЭлементовКлиент()	
//	Если ЯчейкаПолучательСканированно тогда
//	Элементы.ЯчейкаПолучательПредставление.ЦветФона=WebЦвета.Зеленый;
//иначе
//	КонецЕсли;
	ДоступностьВидимостьЭлементовСервер();
КонецПроцедуры
&НаСервере
Процедура ДоступностьВидимостьЭлементовСервер()
	Если Состояние=Перечисления.итWMSСостоянияЗадачТСД.КВыполнению тогда
		Элементы.ИнформативнаяНадпись.Видимость=Ложь;
		Элементы.ИнформативнаяНадпись2.Видимость=Истина;
	иначе
		Элементы.ИнформативнаяНадпись.Видимость=Истина;
		Элементы.ИнформативнаяНадпись2.Видимость=Ложь;
		КонецЕсли;
	КонецПроцедуры
&НаКлиенте
Процедура ОбработчкаПолученияДанныхШтрихКода(Параметр)
Режим=РежимСканирования();	
Если Режим="РежимСканированиеПаллетыНачало" тогда
	Если СокрЛП(Параметр)=СокрЛП(ИдентификаторУпаковки) тогда
		ИнициализацияЗадачиНаСервере(Режим);
		ЗаполнитьЗначенияФормы();
		ДоступностьВидимостьЭлементовКлиент();
	иначе
		ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Отсканированный штрих-код "+Параметр+" не удовлетворяет требованиям");
	КонецЕсли;
КонецЕсли;
Если Режим="РежимСканированияЯчейкиПолучатель" тогда
	ЭтапСканированияЯчейки=ЭтапСканированияЯчейки+1;
	Если НРег(СокрЛП(Параметр))=НРег(СокрЛП(ШтрихКодЯчейкиПолучатель)) тогда
		ЯчейкаПолучательСканированно=Истина;
		Элементы.ИнформативнаяНадпись.Заголовок="Для подтверждения размещения - сканируйте SSCC";
		ДоступностьВидимостьЭлементовКлиент();
		ЭтапСканированияЯчейки=0;
		НакопительСканированияЯчейки="";
		Если ИнициализацияЗадачиНаСервере(Режим) тогда
			ОбщийМодульКлиентскойЧасти.ОповещениеДинамическихСписковОткрытыхФорм();
			НеВозвращатьКонтрольНадТригером=ВладелецФормы.ЗаполнитьДанныеЗадачиКлиентскийВызов();
			ЭтаФорма.Закрыть();
		КонецЕсли;	

	ИначеЕсли ШтрихКодНакопленВерно(Параметр) тогда
		ЯчейкаПолучательСканированно=Истина;
		Элементы.ИнформативнаяНадпись.Заголовок="Для подтверждения размещения - сканируйте SSCC";
		ДоступностьВидимостьЭлементовКлиент();
		ЭтапСканированияЯчейки=0;
		НакопительСканированияЯчейки="";
		Если ИнициализацияЗадачиНаСервере(Режим) тогда
			ОбщийМодульКлиентскойЧасти.ОповещениеДинамическихСписковОткрытыхФорм();
			НеВозвращатьКонтрольНадТригером=ВладелецФормы.ЗаполнитьДанныеЗадачиКлиентскийВызов();
			ЭтаФорма.Закрыть();
		КонецЕсли;	

	ИначеЕсли  НРег(СокрЛП(Параметр))<>НРег(СокрЛП(ШтрихКодЯчейкиПолучатель)) и ЭтапСканированияЯчейки<2 тогда
		НакопительСканированияЯчейки=СокрЛП(Параметр);
	иначе	
	    ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Отсканированный штрих-код "+Параметр+СокрЛП(НакопительСканированияЯчейки)+" не удовлетворяет требованиям");
		ЭтапСканированияЯчейки=0;
		НакопительСканированияЯчейки="";
	КонецЕсли;   	
КонецЕсли;
//Если Режим="РежимСканированиеПаллетыКонец" тогда
//	Если СокрЛП(Параметр)=СокрЛП(ИдентификаторУпаковки) тогда
//		Если ИнициализацияЗадачиНаСервере(Режим) тогда
//			ОбщийМодульКлиентскойЧасти.ОповещениеДинамическихСписковОткрытыхФорм();
//			ЭтаФорма.Закрыть();
//		КонецЕсли;	
//	иначе
//		ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Отсканированный штрих-код "+Параметр+" не соответствует вашей паллете
//		|ван необходимо повторить действие сканирования ячейки получателя,после чего вы снова сможите отсканировать SSCC");
//	    ЯчейкаПолучательСканированно=Ложь;
//			Элементы.ИнформативнаяНадпись.Заголовок="Для подтверждения размещения - сканируйте Ячейку получатель";
//		ДоступностьВидимостьЭлементовКлиент();
//	КонецЕсли;
//КонецЕсли;
КонецПроцедуры
&НаКлиенте
Функция ШтрихКодНакопленВерно(Параметр)
	Если НРег(СокрЛП(НакопительСканированияЯчейки)+СокрЛП(Параметр))=НРег(СокрЛП(ШтрихКодЯчейкиПолучатель)) тогда
		Возврат Истина;
	ИначеЕсли  НРег(СокрЛП(НакопительСканированияЯчейки)+"-"+СокрЛП(Параметр))=НРег(СокрЛП(ШтрихКодЯчейкиПолучатель)) тогда
		Возврат Истина;
	ИначеЕсли НРег(СокрЛП(Параметр)+"-"+СокрЛП(НакопительСканированияЯчейки))=НРег(СокрЛП(ШтрихКодЯчейкиПолучатель)) тогда
		Возврат Истина;
	ИначеЕсли НРег(СокрЛП(Параметр)+СокрЛП(НакопительСканированияЯчейки))=НРег(СокрЛП(ШтрихКодЯчейкиПолучатель)) тогда
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
	КонецФункции
&НаСервере
Функция ИнициализацияЗадачиНаСервере(Режим)
СтруктураДанных= ПолучитьДанныеДляИнициализации();
Если Режим="РежимСканированиеПаллетыНачало" тогда
Возврат ОбработчикДанныхОбщиеФункцииИПроцедуры.ИнициализацияЗадачиНаСервере(СтруктураДанных,"Задача",Перечисления.итWMSСостоянияЗадачТСД.Выполняется);
КонецЕсли;
//Если Режим="РежимСканированиеПаллетыКонец" тогда
Если Режим="РежимСканированияЯчейкиПолучатель" тогда
СтруктураДанных.Вставить("ФиксацияЗадачи",Ложь);
СтруктураИнициализации=СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруИнициализацииДанных(СтруктураДанных,"Задача",Перечисления.итWMSСостоянияЗадачТСД.Выполнена);
//СтруктураИнициализации.Вставить("ТипОбработкиДанных","ВнесениеИзмененийВДокумент");
СтруктураИнициализации.Вставить("ТипОбработкиДанных","ЗаписатьДанныеТСД");
СтруктураИнициализации=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураИнициализации,"Shipment");
Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураИнициализации,"Инициализация") тогда
	Возврат Ложь;
КонецЕсли;	
МодульРаспределенияДанных.ОбработчикВходящихДанных(СтруктураИнициализации);
Возврат СтруктураИнициализации.Инициализация;

//Возврат ОбработчикДанныхОбщиеФункцииИПроцедуры.ИнициализацияЗадачиНаСервере(СтруктураДанных,"Задача",Перечисления.итWMSСостоянияЗадачТСД);
КонецЕсли;
	КонецФункции
&НаСервере
Функция РежимСканирования()
	Если Состояние=Перечисления.итWMSСостоянияЗадачТСД.КВыполнению тогда
		Возврат "РежимСканированиеПаллетыНачало";
	//ИначеЕсли ЯчейкаПолучательСканированно тогда
	//	Возврат "РежимСканированиеПаллетыКонец";
	иначе
		Возврат "РежимСканированияЯчейкиПолучатель";
	КонецЕсли;	
КонецФункции

&НаСервере
Функция ПолучитьДанныеДляИнициализации()
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИтЗадачиНаТСД.ИдЗадачи КАК ИдЗадачи,
	|	ИтЗадачиНаТСД.ТипЗадачи КАК ТипЗадачи,
	|	ИтЗадачиНаТСД.Состояние КАК Состояние
	|ИЗ
	|	РегистрСведений.ИтЗадачиНаТСД КАК ИтЗадачиНаТСД
	|ГДЕ
	|	ИтЗадачиНаТСД.ИдЗадачи = &ИдЗадачи";
	
	Запрос.УстановитьПараметр("ИдЗадачи",ИдЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	СтруктураДанных=новый Структура;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		для Каждого Колонка из РезультатЗапроса.Колонки цикл
			СтруктураДанных.Вставить(Колонка.Имя,ВыборкаДетальныеЗаписи[Колонка.Имя]);
		КонецЦикла;
	КонецЦикла;
	Возврат СтруктураДанных;
	КонецФункции

#КонецОбласти









