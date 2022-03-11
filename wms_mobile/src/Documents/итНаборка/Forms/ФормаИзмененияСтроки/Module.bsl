#Область ОбработчикиСобытий
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не Параметры.Свойство("ИдСтроки") тогда
		Отказ=Истина;
		Возврат
	КонецЕсли;
	Если не Параметры.Свойство("ИдЗадачи") тогда
		Отказ=Истина;
		Возврат
	КонецЕсли;
	ИдЗадачи=Параметры.ИдЗадачи;
	ИдСтроки=Параметры.ИдСтроки;
	ДвиженияЦелойПаллеты();
	ЗАполнитьДаннымиСтрокиФорму();
	ВидимостьДоступностьЭлементовСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
	Если ДвижениеЦелойПаллеты Тогда 
		Элементы.ДекорацияЗаголовокДействия.Заголовок="Это помарочная продукция-сканируйте 
		|SSCC(паллета),GTIN(короб) или марку";
	КонецЕсли;	
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
&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы="Документ.итНаборка.Форма.ФормаАгрегацииМарки" тогда
		ДобавитьМаркуНаСервере(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд
&НаСервере
Процедура ЗавершитьНаСервере()
	НаборЗаписей=РегистрыСведений.ИтСтрокиЗадачНаТСД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдЗадачи.Установить(ИдЗадачи);
	НаборЗаписей.Отбор.ИдСтроки.Установить(ИдСтроки);
	НаборЗаписей.Прочитать();
	для Каждого стр из НаборЗаписей Цикл 
		ДанныеДокументаТСД=стр.ДанныеДокументаТСД.Получить();
		Если ТипЗнч(ДанныеДокументаТСД)=тип("Структура") тогда
			ДанныеДокументаТСД.Вставить("КоличествоФакт",КоличествоФакт);
		иначе
			ДанныеДокументаТСД=новый Структура("КоличествоФакт",КоличествоФакт);
		КонецЕсли;
		стр.ДанныеДокументаТСД=новый ХранилищеЗначения(ДанныеДокументаТСД);
	КонецЦикла;
	НаборЗаписей.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОповещение(Результат,параметры)Экспорт 
	Если Результат=КодВозвратаДиалога.Нет Тогда 
		Возврат
	КонецЕсли;
	ЗавершитьНаСервере();
	ОповеститьОВыборе(новый Структура("Действие,Строка","Изменена",ИдСтроки));
	НеВозвращатьКонтрольНадТригером=Истина;
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

&НаКлиенте
Процедура Завершить(Команда)
	Если КоличествоПлан<>КоличествоФакт Тогда 
		Оповещение=новый ОписаниеОповещения("ЗавершитьОповещение",ЭтаФорма);
		ПоказатьВопрос(Оповещение,"Количество план не равен факту.Только данные факта будут записанны в базу. Продолжить???",РежимДиалогаВопрос.ДаНет);
		Возврат
	КонецЕсли;
	ЗавершитьНаСервере();
	ОповеститьОВыборе(новый Структура("Действие,Строка","Изменена",ИдСтроки));
	НеВозвращатьКонтрольНадТригером=Истина;
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры
&НаКлиенте
Процедура Очистить(Команда)
	ОчиститьНаСервере();
	
КонецПроцедуры
&НаСервере
Процедура ОчиститьНаСервере()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	итДанныеПомарочногоУчета.Марка КАК Марка
	|ИЗ
	|	РегистрСведений.итДанныеПомарочногоУчета КАК итДанныеПомарочногоУчета
	|ГДЕ
	|	итДанныеПомарочногоУчета.Ключ = &Ключ
	|	И итДанныеПомарочногоУчета.Номенклатура = &Номенклатура
	|	И итДанныеПомарочногоУчета.СерияНоменклатуры = &СерияНоменклатуры
	|	И итДанныеПомарочногоУчета.ПризнакОбработки = ИСТИНА
	|	И итДанныеПомарочногоУчета.SSCC = &SSCC";
	
	Запрос.УстановитьПараметр("Ключ", ИдЗадачи);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("СерияНоменклатуры", СерияНоменклатуры);
	Запрос.УстановитьПараметр("SSCC",ИдентификаторУпаковки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборЗаписей=РегистрыСведений.итДанныеПомарочногоУчета.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Марка.Установить(ВыборкаДетальныеЗаписи.Марка);
		НаборЗаписей.Отбор.Ключ.Установить(ИдЗадачи);
		НаборЗаписей.Прочитать();
		Для Каждого  ЭлементЗаписи из НаборЗаписей цикл
			ЭлементЗаписи.ПризнакОбработки=Ложь;
			КоличествоФакт=КоличествоФакт-1;
		КонецЦикла;
		НаборЗаписей.Записать();
		
	КонецЦикла;
	ВосстановитьДанныеРазагрегированныхМарок();
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	НаборЗаписей=РегистрыСведений.ИтСтрокиЗадачНаТСД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдЗадачи.Установить(ИдЗадачи);
	НаборЗаписей.Отбор.ИдСтроки.Установить(ИдСтроки);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество()=0 тогда
		Сообщить("Ошибка данных");
		Возврат
	КонецЕсли;
	для Каждого стр из НаборЗаписей цикл
		ДанныеДокументаТСД= стр.ДанныеДокументаТСД.Получить();
		Если ТипЗнч(ДанныеДокументаТСД) <>тип("Структура") Тогда
			ДанныеДокументаТСД = новый Структура;
		КонецЕсли;
		ДанныеДокументаТСД.Вставить("КоличествоФакт",КоличествоФакт);
		стр.ДанныеДокументаТСД = новый ХранилищеЗначения(ДанныеДокументаТСД);
	КонецЦикла;
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ВидимостьДоступностьЭлементов()
	ВидимостьДоступностьЭлементовСервер();
КонецПроцедуры
&НаСервере
Процедура ВидимостьДоступностьЭлементовСервер() 
	Если ПомарочныйУчет Тогда 
		Элементы.ДекорацияЗаголовокДействия.Видимость=Истина;
		Элементы.КоличествоФакт.ТолькоПросмотр=Истина;
	иначе
		Элементы.ДекорацияЗаголовокДействия.Видимость=Ложь;
		Элементы.КоличествоФакт.ТолькоПросмотр=Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиСтрокиФорму()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИтСтрокиЗадачНаТСД.ИдЗадачи КАК ИдЗадачи,
	|	ИтСтрокиЗадачНаТСД.ИдСтроки КАК ИдСтроки,
	|	ИтСтрокиЗадачНаТСД.Номенклатура КАК Номенклатура,
	|	ИтСтрокиЗадачНаТСД.НоменклатураПредставление КАК НоменклатураПредставление,
	|	ИтСтрокиЗадачНаТСД.ДатаРозлива КАК ДатаРозлива,
	|	ИтСтрокиЗадачНаТСД.СерияНоменклатуры КАК СерияНоменклатуры,
	|	ИтСтрокиЗадачНаТСД.СерияНоменклатурыПредставление КАК СерияНоменклатурыПредставление,
	|	ИтСтрокиЗадачНаТСД.Количество КАК Количество,
	|	ИтСтрокиЗадачНаТСД.ДополнительныеДанные КАК ДополнительныеДанные,
	|	ИтСтрокиЗадачНаТСД.ДанныеДокументаТСД КАК ДанныеДокументаТСД
	|ИЗ
	|	РегистрСведений.ИтСтрокиЗадачНаТСД КАК ИтСтрокиЗадачНаТСД
	|ГДЕ
	|	ИтСтрокиЗадачНаТСД.ИдЗадачи = &ИдЗадачи
	|	И ИтСтрокиЗадачНаТСД.ИдСтроки = &ИдСтроки";
	
	Запрос.УстановитьПараметр("ИдЗадачи", ИдЗадачи);
	Запрос.УстановитьПараметр("ИдСтроки", ИдСтроки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ЭтаФорма,ВыборкаДетальныеЗаписи);
		КоличествоПлан=ВыборкаДетальныеЗаписи.Количество;
		ДанныеДокументаТСД=ВыборкаДетальныеЗаписи.ДанныеДокументаТСД.Получить();
		Если ТипЗнч(ДанныеДокументаТСД)=тип("Структура") тогда
			ЗаполнитьЗначенияСвойств(ЭтаФорма,ДанныеДокументаТСД);
		КонецЕсли;	
		ДополнительныеДанные=ВыборкаДетальныеЗаписи.ДополнительныеДанные.Получить();
		Если ТипЗнч(ДополнительныеДанные) = тип("Структура") тогда
			ЗаполнитьЗначенияСвойств(ЭтаФорма,ДополнительныеДанные);
			ИдентификаторУпаковки=ДополнительныеДанные.ИдентификаторУпаковкиОтправитель;
		КонецЕсли;
	КонецЦикла;
	Если ПомарочныйУчет Тогда 
		КоличествоФакт=ПолучитьКоличествоОтсканированныхМарокТекущейПродукции();
	КонецЕсли;
	
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчкаПолученияДанныхШтрихКода(Параметр)
	Если ПомарочныйУчет Тогда 
		ОбработчикСканированияПомарочногоУчета(Параметр)
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура ОбработчикСканированияПомарочногоУчета(Параметр)
	ДанныеШтрихКода=Параметр;
	Если ДвижениеЦелойПаллеты Тогда 
		Отказ=Ложь;
		СлужебныеФункцииИПроцедурыКлиентСервер.ПроверитьSSCCНаЛеквидность(ДанныеШтрихКода,Отказ,Ложь);
		Если не Отказ Тогда
			ПолучениеИЗаписьПомарочныхДанныхПоШк(Параметр,Истина,);
			Возврат
		КонецЕсли;
	КонецЕсли;
	Отказ=Ложь;
	СлужебныеФункцииИПроцедурыКлиентСервер.ПроверитьGTINНаЛеквидность(ДанныеШтрихКода,Отказ,Ложь);
	Если не Отказ Тогда
		ПолучениеИЗаписьПомарочныхДанныхПоШк(Параметр,,Истина);
		Возврат
	КонецЕсли;
	Если СтрДлина(Параметр)=68 или СтрДлина(Параметр)=150 тогда
		ОткрытьФорму("Документ.итНаборка.Форма.ФормаАгрегацииМарки",новый Структура("ДанныеМарки",новый Структура("Марка",Параметр)),ЭтаФорма);
		ТригерПриемаСканераШтрихКода=Ложь;
		Возврат
	КонецЕсли;
	Сообщить("Не верный формат ШК");
	
	
КонецПроцедуры
&НаСервере
Процедура ПолучениеИЗаписьПомарочныхДанныхПоШк(Параметр,SSCC=Ложь,GTIN=Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	итДанныеПомарочногоУчета.Марка КАК Марка,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА итДанныеПомарочногоУчета.Номенклатура = &ПустойГуид
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ОшибкаНоменклатурыКороба,
	|	итДанныеПомарочногоУчета.Ключ КАК Ключ,
	|	ВЫБОР
	|		КОГДА итДанныеПомарочногоУчета.Номенклатура <> &Номенклатура
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НоменклатураНеСоответствуетОтбору,
	|	ВЫБОР
	|		КОГДА итДанныеПомарочногоУчета.СерияНоменклатуры <> &СерияНоменклатуры
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СерияНеСоответствуетОтбору,
	|	МАКСИМУМ(итДанныеПомарочногоУчета.ПризнакОбработки) КАК ПризнакОбработки,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА итДанныеПомарочногоУчета.SSCC <> &ИдентификаторУпаковки
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК МаркаНеПринадлежитТекущемуSSCC
	|ПОМЕСТИТЬ МаркиШтрихКода
	|ИЗ
	|	РегистрСведений.итДанныеПомарочногоУчета КАК итДанныеПомарочногоУчета
	|ГДЕ
	|	итДанныеПомарочногоУчета.Ключ = &Ключ
	|	И ВЫБОР
	|			КОГДА &Gtin
	|				ТОГДА итДанныеПомарочногоУчета.GTIN = &ШтрихКод
	|			ИНАЧЕ итДанныеПомарочногоУчета.SSCC = &ШтрихКод
	|		КОНЕЦ
	|
	|СГРУППИРОВАТЬ ПО
	|	итДанныеПомарочногоУчета.Марка,
	|	итДанныеПомарочногоУчета.Ключ,
	|	ВЫБОР
	|		КОГДА итДанныеПомарочногоУчета.Номенклатура <> &Номенклатура
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА итДанныеПомарочногоУчета.СерияНоменклатуры <> &СерияНоменклатуры
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МаркиШтрихКода.Ключ КАК Ключ,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ МаркиШтрихКода.Марка) КАК Марка,
	|	МАКСИМУМ(МаркиШтрихКода.ОшибкаНоменклатурыКороба) КАК ОшибкаНоменклатурыКороба,
	|	МАКСИМУМ(МаркиШтрихКода.НоменклатураНеСоответствуетОтбору) КАК НоменклатураНеСоответствуетОтбору,
	|	МАКСИМУМ(МаркиШтрихКода.СерияНеСоответствуетОтбору) КАК СерияНеСоответствуетОтбору,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА НЕ МаркиШтрихКода.ПризнакОбработки
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ПризнакНеПолностьюОбработанныхМарок,
	|	МаркиШтрихКода.МаркаНеПринадлежитТекущемуSSCC КАК МаркаНеПринадлежитТекущемуSSCC
	|ИЗ
	|	МаркиШтрихКода КАК МаркиШтрихКода
	|
	|СГРУППИРОВАТЬ ПО
	|	МаркиШтрихКода.Ключ,
	|	МаркиШтрихКода.МаркаНеПринадлежитТекущемуSSCC
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МаркиШтрихКода.Марка КАК Марка,
	|	МаркиШтрихКода.Ключ КАК Ключ
	|ИЗ
	|	МаркиШтрихКода КАК МаркиШтрихКода
	|ГДЕ
	|	МаркиШтрихКода.ПризнакОбработки = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	МаркиШтрихКода.Марка,
	|	МаркиШтрихКода.Ключ";
	
	Запрос.УстановитьПараметр("GTIN", GTIN);
	Запрос.УстановитьПараметр("SSCC", SSCC);
	Запрос.УстановитьПараметр("ИдентификаторУпаковки",ИдентификаторУпаковки);
	Запрос.УстановитьПараметр("Ключ", ИдЗадачи);
	Запрос.УстановитьПараметр("ПустойГуид",СлужебныеФункцииИПроцедурыКлиентСервер.ПустойУникальныйИдентификатор());
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("СерияНоменклатуры", СерияНоменклатуры);
	Запрос.УстановитьПараметр("ШтрихКод", Параметр);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаНаОшибку=МассивРезультатов[1].Выбрать();
	Ошибка = Ложь;
	Пока ВыборкаНаОшибку.Следующий() Цикл
		Если ВыборкаНаОшибку.ОшибкаНоменклатурыКороба Тогда 
			Сообщить("В коробе/паллете числится номенклатура не из текущей строки задачи, попробуйте 
			|сканировать кажду марку или возьмите другой короб");
			Ошибка=Истина;
		ИначеЕсли  ВыборкаНаОшибку.НоменклатураНеСоответствуетОтбору Тогда 
			Сообщить("В коробе/паллете числится не текущая номенклатура или короб не однороден, попробуйте 
			|сканировать кажду марку или возьмите другой короб");
			Ошибка=Истина;
		ИначеЕсли  ВыборкаНаОшибку.СерияНеСоответствуетОтбору Тогда 
			Сообщить("В коробе числится верная номенклатура,но
			|серия не соответствует отбору или короб не однороден, попробуйте 
			|сканировать кажду марку или возьмите другой короб");
			Ошибка=Истина; 
		КонецЕсли;
		Если КоличествоФакт+ВыборкаНаОшибку.Марка > КоличествоПлан Тогда 
			Сообщить("вместе с текущем коробом/паллетой вы набираете марок больше чем по плану("+Строка(КоличествоПлан)+"-"+Строка(КоличествоФакт+ВыборкаНаОшибку.Марка)+") , короб не засчитан");
			Ошибка=Истина;
		КонецЕсли;
		Если не ВыборкаНаОшибку.ПризнакНеПолностьюОбработанныхМарок тогда
			Сообщить("Текущие марки уже числятся в обработанных");
			Ошибка=Истина;
		КонецЕсли;
		Если  ВыборкаНаОшибку.МаркаНеПринадлежитТекущемуSSCC тогда
			Сообщить("Текущие марки не принадлежит SSCC отправителю");
			Ошибка=Истина;
		КонецЕсли;
		
	КонецЦикла;
	Если МассивРезультатов[2].Пустой() Тогда 
		Ошибка=Истина;
		Сообщить("Нет данных марок");
	КонецЕсли;	
	
	Если Ошибка Тогда 
		Возврат
	КонецЕсли;
	ВыборкаДетальныеЗаписи = МассивРезультатов[2].Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборЗаписей=РегистрыСведений.итДанныеПомарочногоУчета.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Марка.Установить(ВыборкаДетальныеЗаписи.Марка);
		НаборЗаписей.Отбор.Ключ.Установить(ВыборкаДетальныеЗаписи.Ключ);
		НаборЗаписей.Прочитать();
		Для Каждого  ЭлементЗаписи из НаборЗаписей цикл
			ЭлементЗаписи.ПризнакОбработки=Истина;
			КоличествоФакт=КоличествоФакт+1;
		КонецЦикла;
		НаборЗаписей.Записать();
	КонецЦикла;
	
	
КонецПроцедуры

&НаСервере	
Процедура ДобавитьМаркуНаСервере(ДанныеМарки)
	Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(ДанныеМарки,"Марка") Тогда 
		Возврат
	КонецЕсли;
	Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(ДанныеМарки,"GTINАгрегации") Тогда 
		Возврат
	КонецЕсли;
	
	НаборЗаписей=РегистрыСведений.итДанныеПомарочногоУчета.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Ключ.Установить(ИдЗадачи);
	НаборЗаписей.Отбор.Марка.Установить(ДанныеМарки.Марка);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество()=0 Тогда 
		Сообщить("Марка не числится в текущей строке наборки");
		Возврат
	КонецЕсли;
	для Каждого стр из НаборЗаписей цикл
		Если стр.Номенклатура<>Номенклатура Тогда 
			Сообщить("Марка не относиться к необходимой номенклатуре");
			Возврат
		КонецЕсли;	
		Если стр.СерияНоменклатуры<>СерияНоменклатуры Тогда 
			Сообщить("Марка не относиться к необходимой серии");
			Возврат
		КонецЕсли;	
		Если стр.SSCC<>ИдентификаторУпаковки Тогда 
			Сообщить("Марка не относиться к необходимому идентификатору");
			Возврат
		КонецЕсли;
		
		Если не стр.ПризнакОбработки  Тогда 
			стр.ПризнакОбработки=Истина;
			КоличествоФакт=КоличествоФакт+1;
			ЗаписатьИсториюИзмененияАгрегацииМарки(ДанныеМарки.Марка);
		иначе
			Сообщить("Марка уже в зачислена");
		КонецЕсли;
		стр.GTIN=ДанныеМарки.GTINАгрегации;
	КонецЦикла;
	НаборЗаписей.Записать();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИсториюИзмененияАгрегацииМарки(Марка)
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	GTINПоУмолчанию="";
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	итДанныеПомарочногоУчета.GTIN КАК GTIN
	|ИЗ
	|	РегистрСведений.итДанныеПомарочногоУчета КАК итДанныеПомарочногоУчета
	|ГДЕ
	|	итДанныеПомарочногоУчета.Марка = &Марка
	|	И итДанныеПомарочногоУчета.Ключ = &Ключ";
	
	Запрос.УстановитьПараметр("Ключ", ИдЗадачи);
	Запрос.УстановитьПараметр("Марка", Марка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда 
		GTINПоУмолчанию=ВыборкаДетальныеЗаписи.GTIN;	
	КонецЕсли;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
	
	НаборЗаписей=РегистрыСведений.ИтСтрокиЗадачНаТСД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдЗадачи.Установить(ИдЗадачи);
	НаборЗаписей.Отбор.ИдСтроки.Установить(ИдСтроки);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество()=0 тогда
		Сообщить("Ошибка данных");
		Возврат
	КонецЕсли;
	для Каждого стр из НаборЗаписей цикл
		ДанныеДокументаТСД= стр.ДанныеДокументаТСД.Получить();
		Если ТипЗнч(ДанныеДокументаТСД)<>тип("Структура") Тогда
			ДанныеДокументаТСД = новый Структура;
		КонецЕсли;
		Если  ДанныеДокументаТСД.Свойство("ТаблицаПереагрегированныйМарок") тогда
			ТаблицаПереагрегированныйМарок=ДанныеДокументаТСД.ТаблицаПереагрегированныйМарок;
		иначе
			ТаблицаПереагрегированныйМарок =новый ТаблицаЗначений;
			ТаблицаПереагрегированныйМарок.Колонки.Добавить("Марка");
			ТаблицаПереагрегированныйМарок.Колонки.Добавить("GTINПоУмолчанию");
		КонецЕсли;	
		НоваяСтрока=ТаблицаПереагрегированныйМарок.Добавить();
		НоваяСтрока.Марка=Марка;
		НоваяСтрока.GTINПоУмолчанию=GTINПоУмолчанию;
		ДанныеДокументаТСД.Вставить("ТаблицаПереагрегированныйМарок",ТаблицаПереагрегированныйМарок);
		стр.ДанныеДокументаТСД = новый ХранилищеЗначения(ДанныеДокументаТСД);
	КонецЦикла;
	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьДанныеРазагрегированныхМарок()
	
	НаборЗаписей=РегистрыСведений.ИтСтрокиЗадачНаТСД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдЗадачи.Установить(ИдЗадачи);
	НаборЗаписей.Отбор.ИдСтроки.Установить(ИдСтроки);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество()=0 тогда
		Сообщить("Ошибка данных");
		Возврат
	КонецЕсли;
	для Каждого стр из НаборЗаписей цикл
		
		ДанныеДокументаТСД= стр.ДанныеДокументаТСД.Получить();
		
		Если ТипЗнч(ДанныеДокументаТСД)<>тип("Структура") Тогда
			ДанныеДокументаТСД = новый Структура;
		КонецЕсли;
		
		Если  ДанныеДокументаТСД.Свойство("ТаблицаПереагрегированныйМарок") тогда
			ТаблицаПереагрегированныйМарок=ДанныеДокументаТСД.ТаблицаПереагрегированныйМарок;
			
			
			для Каждого СтрокаДанныхИсторииАгрегации из ТаблицаПереагрегированныйМарок цикл
				НаборЗаписей=РегистрыСведений.итДанныеПомарочногоУчета.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Ключ.Установить(ИдЗадачи);
				НаборЗаписей.Отбор.Марка.Установить(СтрокаДанныхИсторииАгрегации.Марка);
				НаборЗаписей.Прочитать();
				Если НаборЗаписей.Количество()=0 Тогда 
					Сообщить("Потеря данных-откажитесь от задачи и возьмите заного");
					Возврат
				КонецЕсли;
				для Каждого СтрокаДанныхМарки из НаборЗаписей цикл
					СтрокаДанныхМарки.GTIN=СтрокаДанныхИсторииАгрегации.GTINПоУмолчанию;
				КонецЦикла;
				НаборЗаписей.Записать();
				
			КонецЦикла;
			ДанныеДокументаТСД.Вставить("ТаблицаПереагрегированныйМарок",ТаблицаПереагрегированныйМарок);
			стр.ДанныеДокументаТСД = новый ХранилищеЗначения(ДанныеДокументаТСД);
			
		КонецЕсли;	
		
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаСервере		
Функция ПолучитьКоличествоОтсканированныхМарокТекущейПродукции()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ итДанныеПомарочногоУчета.Марка) КАК Марка,
	|	итДанныеПомарочногоУчета.Ключ КАК Ключ
	|ИЗ
	|	РегистрСведений.итДанныеПомарочногоУчета КАК итДанныеПомарочногоУчета
	|ГДЕ
	|	итДанныеПомарочногоУчета.Ключ = &Ключ
	|	И итДанныеПомарочногоУчета.Номенклатура = &Номенклатура
	|	И итДанныеПомарочногоУчета.СерияНоменклатуры = &СерияНоменклатуры
	|	И итДанныеПомарочногоУчета.ПризнакОбработки = ИСТИНА
	|	И итДанныеПомарочногоУчета.SSCC = &SSCC
	|
	|СГРУППИРОВАТЬ ПО
	|	итДанныеПомарочногоУчета.Ключ";
	
	Запрос.УстановитьПараметр("Ключ", ИдЗадачи);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("СерияНоменклатуры", СерияНоменклатуры);
	Запрос.УстановитьПараметр("SSCC",ИдентификаторУпаковки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда 
		Возврат   ВыборкаДетальныеЗаписи.Марка;
	КонецЕсли;
	Возврат 0;
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции
&НаСервере
Процедура  ДвиженияЦелойПаллеты()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИтЗадачиНаТСД.ДополнительныеДанные КАК ДополнительныеДанные
	|ИЗ
	|	РегистрСведений.ИтЗадачиНаТСД КАК ИтЗадачиНаТСД
	|ГДЕ
	|	ИтЗадачиНаТСД.ИдЗадачи = &ИдЗадачи";
	
	Запрос.УстановитьПараметр("ИдЗадачи", ИдЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДополнительныеДанные=ВыборкаДетальныеЗаписи.ДополнительныеДанные.Получить();
		Если  ТипЗнч(ДополнительныеДанные)=Тип("Структура") Тогда 
			Если ДополнительныеДанные.Свойство("ДвижениеЦелойПаллеты") Тогда 
				ДвижениеЦелойПаллеты=ДополнительныеДанные.ДвижениеЦелойПаллеты;
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецПроцедуры
#КонецОбласти




