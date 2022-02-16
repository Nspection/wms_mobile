
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не Параметры.Свойство("ОбъектДанных") тогда	
		Отказ=Истина;
		Возврат
	КонецЕсли;
	Если не Параметры.Свойство("SSCC") тогда
		Отказ=Истина;
		Возврат
	КонецЕсли;
	Объект=Параметры.ОбъектДанных;
	SSCC=Параметры.SSCC;
	
	ЗаполитьДАннымSSCC();
КонецПроцедуры

&НаСервере
Процедура ЗаполитьДАннымSSCC()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	итДокументСвободнойАгрегацииДанныеАгрегации.SSCC КАК SSCC,
	|	итДокументСвободнойАгрегацииДанныеАгрегации.GTIN КАК GTIN,
	|	итДокументСвободнойАгрегацииДанныеАгрегации.Интервал КАК Интервал,
	|	итДокументСвободнойАгрегацииДанныеАгрегации.Марка КАК Марка
	|ИЗ
	|	Документ.итДокументСвободнойАгрегации.ДанныеАгрегации КАК итДокументСвободнойАгрегацииДанныеАгрегации
	|ГДЕ
	|	итДокументСвободнойАгрегацииДанныеАгрегации.Ссылка = &Ссылка
	|	И итДокументСвободнойАгрегацииДанныеАгрегации.SSCC = &SSCC
	|	И итДокументСвободнойАгрегацииДанныеАгрегации.Марка <> """"";
	
	Запрос.УстановитьПараметр("SSCC", SSCC);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	СоставляющиеSSCC.Очистить();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СоставляющиеSSCC.Добавить(),ВыборкаДетальныеЗаписи)
	КонецЦикла;
	Количество=СоставляющиеSSCC.Количество();
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ОбработчикШтрихКода"  и ТригерПриемаСканераШтрихКода тогда
		Если Параметр=404 и Источник="ОшибкаЧтения" тогда
			ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Штрих код некорректен");
			Возврат
		КонецЕсли;
		ПроверитьШтрихКодНаФормат(Параметр);
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура ПроверитьШтрихКодНаФормат(ШтрихКод)
	ШтрихКодОбработан=Ложь;
	ПроверитьШтрихКодНаФорматСервер(ШтрихКод,ШтрихКодОбработан);
	Если ШтрихКодОбработан тогда
		Если GTINВДругомSSCC(ШтрихКод) тогда
			Возврат
		КонецЕсли;	
		ОткрытьФорму("Документ.итДокументСвободнойАгрегации.Форма.ФормаGTIN",новый Структура("ОбъектДанных,SSCC,GTIN",Объект,SSCC,СокрЛП(ШтрихКод)),ЭтаФорма);
		ТригерПриемаСканераШтрихКода=Ложь;
	Иначе 
		Сообщить("не верный формат штрих кода");
	КонецЕсли;
КонецПроцедуры
&НаСервере
Процедура ПроверитьШтрихКодНаФорматСервер(ШтрихКод,ШтрихКодОбработан)
	Если СтрДлина(ШтрихКод)=26 тогда
		ОбработчикШтрхкода26Символов(ШтрихКод,ШтрихКодОбработан);
	КонецЕсли;
	//Если СтрДлина(ШтрихКод)=20 или СтрДлина(ШтрихКод)=18 тогда
	//	ОбработчикSSCC(ШтрихКод,ШтрихКодОбработан);
	//КонецЕсли;	
КонецПроцедуры
&НаСервере
Процедура ОбработчикШтрхкода26Символов(ШтрихКод,ШтрихКодОбработан)
	ТаблицаДанныхДобавления=Неопределено;
	ТипЛогистическойЕденицы=Сред(ШтрихКод,13,1);
	Попытка
		ТипЛогистическойЕденицы=Число(ТипЛогистическойЕденицы);
	Исключение
		Сообщить("Не возможно определить тип логистической еденицы");
	КонецПопытки;
	
	Если ТипЛогистическойЕденицы=1 или ТипЛогистическойЕденицы=3 тогда
		ШтрихКодОбработан=Истина;
	КонецЕсли;	
КонецПроцедуры
&НаСервере
Функция GTINВДругомSSCC(ШтрихКод)
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	итДокументСвободнойАгрегацииДанныеАгрегации.GTIN КАК GTIN,
	|	итДокументСвободнойАгрегацииДанныеАгрегации.SSCC КАК SSCC
	|ИЗ
	|	Документ.итДокументСвободнойАгрегации.ДанныеАгрегации КАК итДокументСвободнойАгрегацииДанныеАгрегации
	|ГДЕ
	|	итДокументСвободнойАгрегацииДанныеАгрегации.GTIN = &GTIN
	|	И итДокументСвободнойАгрегацииДанныеАгрегации.SSCC <> &SSCC
	|	И итДокументСвободнойАгрегацииДанныеАгрегации.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("GTIN", СокрЛП(ШтрихКод));
	Запрос.УстановитьПараметр("SSCC", SSCC);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() тогда
		Сообщить("идентификатор коробки,Уже числится в другом SSCC");
		Возврат Истина;
	КонецЕсли;	
	Возврат Ложь;
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции

&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	Оповещение = новый ОписаниеОповещения("ОчиститьОповещение",ЭтаФорма);
	ПоказатьВопрос(Оповещение,"Вы точно хотите очистить данные паллеты",РежимДиалогаВопрос.ДаНет);
КонецПроцедуры
&НаКлиенте
Процедура ОчиститьОповещение(Результат,Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет тогда
		Возврат
	КонецЕсли;
	ОчиститьНаСервере();
	ЭтаФорма.Закрыть();	
КонецПроцедуры
&НаСервере
Процедура ОчиститьНаСервере()
	ОбъектДанных = Объект.ПолучитьОбъект();
	Строки=ОбъектДанных.ДанныеАгрегации.НайтиСтроки(новый Структура("SSCC",SSCC));
	для Каждого стр из Строки цикл
		ОбъектДанных.ДанныеАгрегации.Удалить(стр);
	КонецЦикла;
	ОбъектДанных.Записать();
	СоставляющиеSSCC.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ЗаполитьДАннымSSCC();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры
