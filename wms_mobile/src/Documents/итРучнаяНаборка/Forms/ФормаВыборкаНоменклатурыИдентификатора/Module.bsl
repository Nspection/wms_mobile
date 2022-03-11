
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не Параметры.Свойство("МассивДанных") Тогда 
		Отказ=Истина;
		Возврат;
	КонецЕсли;
	Если Параметры.Сообщение="" Тогда 
		Элементы.ПосмотретьСлужебноеСообщение.Видимость=Ложь;
	иначе
		Элементы.ПосмотретьСлужебноеСообщение.Видимость=Истина;
	КонецЕсли;
	Объект=Параметры.Объект;
	ИдентификаторУпаковки=Параметры.ИдентификаторУпаковки;
	Для Каждого стр из Параметры.МассивДанных цикл
		НоваяСтрока=ДанныеВыбора.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,стр);
		НоваяСтрока.ИдентификаторСтроки=новый УникальныйИдентификатор();
	КонецЦикла;
	ЗаполнитьСпискиВыбора();
Если ДанныеВыбора.Количество()=1 Тогда 
	СерияНоменклатурыПредставление=ДанныеВыбора[0].СерияНоменклатурыПредставление;
	НоменклатураПредставление=ДанныеВыбора[0].НоменклатураПредставление;
    Номенклатура=ДанныеВыбора[0].Номенклатура;
    СерияНоменклатуры= ДанныеВыбора[0].СерияНоменклатуры;
	Количество=ДанныеВыбора[0].Количество;
	ДатаРозлива=ДанныеВыбора[0].ДатаРозлива;
	Ячейка= ДанныеВыбора[0].Ячейка;
	ЯчейкаПредставление=ДанныеВыбора[0].ЯчейкаПредставление;
	КоличествоВПаллете=ДанныеВыбора[0].Количество;
	Качество=ДанныеВыбора[0].Качество;
	НоменклатураПредставлениеВыбор=Строка(ДанныеВыбора[0].ИдентификаторСтроки);
    СерияНоменклатурыПредставлениеВыбор=Строка(ДанныеВыбора[0].ИдентификаторСтроки);
	ПолучитьОставшеесяКоличествономенклатурыКнабору();
	КоличествоОсталось=КоличествоОсталось-Количество;
КонецЕсли;
КонецПроцедуры
&НаСервере
Процедура ЗаполнитьСпискиВыбора()
	Для Каждого стр из ДанныеВыбора цикл
		Элементы.НоменклатураПредставление.СписокВыбора.Добавить(Строка(стр.ИдентификаторСтроки),стр.НоменклатураПредставление);
		Элементы.СерияНоменклатурыПредставление.СписокВыбора.Добавить(Строка(стр.ИдентификаторСтроки),стр.СерияНоменклатурыПредставление);
	КонецЦикла;
	КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьСлужебноеСообщение(Команда)
		Сообщить(Параметры.Сообщение);
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПредставлениеПриИзменении(Элемент)
	ИдентификаторСтроки=новый УникальныйИдентификатор(НоменклатураПредставлениеВыбор);
	Строки=ДанныеВыбора.НайтиСтроки(новый Структура("ИдентификаторСтроки",ИдентификаторСтроки));
	Элементы.СерияНоменклатурыПредставление.СписокВыбора.Очистить();
	Для Каждого стр из Строки цикл
			Элементы.СерияНоменклатурыПредставление.СписокВыбора.Добавить(Строка(стр.ИдентификаторСтроки),стр.СерияНоменклатурыПредставление);
			НоменклатураПредставление=стр.НоменклатураПредставление;
			Количество=стр.Количество;
			КоличествоВПаллете=стр.Количество;
			Ячейка=стр.Ячейка;
			ЯчейкаПредставление=стр.ЯчейкаПредставление;
			ДатаРозлива=стр.ДатаРозлива;
			Качество=стр.Качество;
	КонецЦикла; 
	ПолучитьОставшеесяКоличествономенклатурыКнабору();
	КоличествоОсталось=КоличествоОсталось-Количество;
КонецПроцедуры
&НаСервере
Процедура ПолучитьОставшеесяКоличествономенклатурыКнабору()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	итРучнаяНаборкаДанныеЗаказа.Номенклатура КАК Номенклатура,
		|	итРучнаяНаборкаДанныеЗаказа.КоличествоПлан КАК КоличествоПлан,
		|	итРучнаяНаборкаДанныеЗаказа.КоличествоФакт КАК КоличествоФакт
		|ИЗ
		|	Документ.итРучнаяНаборка.ДанныеЗаказа КАК итРучнаяНаборкаДанныеЗаказа
		|ГДЕ
		|	итРучнаяНаборкаДанныеЗаказа.Ссылка = &Ссылка
		|	И итРучнаяНаборкаДанныеЗаказа.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Ссылка", Объект);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КоличествоОсталось=ВыборкаДетальныеЗаписи.КоличествоПлан-ВыборкаДетальныеЗаписи.КоличествоФакт;
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
	КонецПроцедуры

&НаКлиенте
Процедура СерияНоменклатурыПредставлениеПриИзменении(Элемент)
	ИдентификаторСтроки=новый УникальныйИдентификатор(СерияНоменклатурыПредставлениеВыбор);
	Строки=ДанныеВыбора.НайтиСтроки(новый Структура("ИдентификаторСтроки",ИдентификаторСтроки));
	Элементы.НоменклатураПредставление.СписокВыбора.Очистить();
	Для Каждого стр из Строки цикл
			Элементы.НоменклатураПредставление.СписокВыбора.Добавить(Строка(стр.ИдентификаторСтроки),стр.НоменклатураПредставление);
			СерияНоменклатурыПредставление=стр.СерияНоменклатурыПредставление;
			НоменклатураПредставление=стр.НоменклатураПредставление;
			Количество=стр.Количество;
			КоличествоВПаллете=стр.Количество;
			Ячейка=стр.Ячейка;
			ЯчейкаПредставление=стр.ЯчейкаПредставление;
			ДатаРозлива=стр.ДатаРозлива;
			Качество=стр.Качество;
		КонецЦикла;   
	ПолучитьОставшеесяКоличествономенклатурыКнабору();
	КоличествоОсталось=КоличествоОсталось-Количество;
КонецПроцедуры


&НаКлиенте
Процедура Добавить(Команда)
	Если КоличествоОсталось<0 Тогда 
		Сообщить("Вы пытаетесь забрать больше , чем нужно");
		Возврат
	КонецЕсли;	
	Если СерияНоменклатурыПредставление="" Тогда 
		Сообщить("Не выбрана серия");
		Возврат
	КонецЕсли;	
	СтруктураДанных=новый Структура;
	СтруктураДанных.Вставить("Номенклатура",Номенклатура);
	СтруктураДанных.Вставить("НоменклатураПредставление",НоменклатураПредставление);
	СтруктураДанных.Вставить("СерияНоменклатуры",СерияНоменклатуры);
	СтруктураДанных.Вставить("СерияНоменклатурыПредставление",СерияНоменклатурыПредставление);
	СтруктураДанных.Вставить("ДатаРозлива",ДатаРозлива);
    СтруктураДанных.Вставить("Количество",Количество);
	СтруктураДанных.Вставить("Качество",Качество);
	СтруктураДанных.Вставить("Ячейка",Ячейка);
    СтруктураДанных.Вставить("ЯчейкаПредставление",ЯчейкаПредставление);
    СтруктураДанных.Вставить("ИдентификаторУпаковки",ИдентификаторУпаковки);

	ОповеститьОВыборе(СтруктураДанных);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	Если Количество>КоличествоВПаллете Тогда 
		 Количество=КоличествоВПаллете;
		 Сообщить("не возможно взять больше чем в паллете");
	КонецЕсли;	 
	ПолучитьОставшеесяКоличествономенклатурыКнабору();
	КоличествоОсталось=КоличествоОсталось-Количество;
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры
