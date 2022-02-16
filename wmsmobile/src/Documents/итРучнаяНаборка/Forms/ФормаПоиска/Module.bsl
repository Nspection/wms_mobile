
&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
НоменклатураПредставление=Параметры.НоменклатураПредставление;
Номенклатура=Параметры.Номенклатура;
СсылкаНаОбъект=Параметры.СсылкаНаОбъект;
ЗаполнитьДанныеПоиска();
КонецПроцедуры

Процедура ЗаполнитьДанныеПоиска()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	итРучнаяНаборкаДанныеЯчеечногоУчета.ЯчейкаПредставление КАК ЯчейкаПредставление,
		|	итРучнаяНаборкаДанныеЯчеечногоУчета.ДатаРозлива КАК ДатаРозлива,
		|	итРучнаяНаборкаДанныеЯчеечногоУчета.Количество КАК Количество,
		|	итРучнаяНаборкаДанныеЯчеечногоУчета.ЯчейкаУжеИспользуется КАК ЯчейкаУжеИспользуется
		|ИЗ
		|	Документ.итРучнаяНаборка.ДанныеЯчеечногоУчета КАК итРучнаяНаборкаДанныеЯчеечногоУчета
		|ГДЕ
		|	итРучнаяНаборкаДанныеЯчеечногоУчета.Ссылка = &Ссылка
		|	И итРучнаяНаборкаДанныеЯчеечногоУчета.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	СписокЯчеекСДанными.Очистить();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СписокЯчеекСДанными.Добавить(),ВыборкаДетальныеЗаписи)
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
	КонецПроцедуры

&НаКлиенте
Процедура СписокЯчеекСДаннымиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ДобавлениеДанныхРучнаяНаборка" Тогда
		ПодключитьОбработчикОжидания("ЗапускОбновленияДанных",0.5,Истина);
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура ЗапускОбновленияДанных()Экспорт 
	ЗаполнитьДанныеПоиска();
	КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанные(Команда)
 ВладелецФормы.ОбновлениеДанныхЯчеечногоУчета(новый Структура("НоменклатураПредставление,Номенклатура,СсылкаНаОбъект",НоменклатураПредставление,Номенклатура,СсылкаНаОбъект));
 ЭтаФорма.Закрыть();
КонецПроцедуры
