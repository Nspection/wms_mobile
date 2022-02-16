&НаСервере
Процедура ПолучитьТекущиеДокументы()
	СтруктураЗапроса = униОбщийМодуль.НоваяСтруктураЗапросакUWS();
	СтруктураЗапроса.Вставить("ИмяМетода","ПолучитьДокументыОтрузки");
	Попытка
		ОтветСервера =  униОбщийМодуль.ДанныеИзUWS(СтруктураЗапроса);
	Исключение
		УспехАвторизации = Ложь;
		ОтветСервера = "Ошибка";
	КонецПопытки; 
	
	Если ТипЗнч(ОтветСервера) = Тип("Структура") Тогда
		Если ОтветСервера.Свойство("ПереченьДокументовНаДату") Тогда
			ТЗ = ОтветСервера.ПереченьДокументовНаДату;
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТЗ.ГУИД КАК ГУИД,
			|	ТЗ.ПредставлениеДокумента КАК ПредставлениеДокумента,
			|	ТЗ.ПредставлениеТранспорта КАК ПредставлениеТранспорта,
			|	ТЗ.ПризнакТ КАК ПризнакТ
			|ПОМЕСТИТЬ Т1
			|ИЗ
			|	&ТЗ КАК ТЗ
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Т1.ГУИД КАК ГУИД,
			|	Т1.ПредставлениеДокумента КАК ПредставлениеДокумента,
			|	Т1.ПредставлениеТранспорта КАК ПредставлениеТранспорта,                 
			|	униНаборкаАгрегация.Ссылка КАК Ссылка,
			|	Т1.ПризнакТ КАК ПризнакТ
			|ИЗ
			|	Т1 КАК Т1
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.униНаборкаАгрегация КАК униНаборкаАгрегация
			|		ПО Т1.ГУИД = униНаборкаАгрегация.ТТНЕГАИС";
			Запрос.УстановитьПараметр("ТЗ", ТЗ);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			МассивДнов = Новый Массив;
			ВремТЗ =  РезультатЗапроса.Выгрузить();
			а=1;
			Для каждого ТекТз Из ВремТЗ Цикл
				Попытка
				Если не ЗначениеЗаполнено(ТекТз.Ссылка) Тогда
					ДокОбъект = Документы.униНаборкаАгрегация.СоздатьДокумент();
					ДокОбъект.ТТНЕГАИС = ТекТз.ГУИД;	
					ВновьСоздан  =Истина;
				иначе	
					ДокОбъект =  ТекТз.Ссылка.ПолучитьОбъект();
					ВновьСоздан  =Ложь;
				КонецЕсли; 
				ДокОбъект.Дата = ТекущаяДата();
				ДокОбъект.ПризнакТ = ТекТз.ПризнакТ;   
				//ДокОбъект.ПризнакТ = Ложь;
				ДокОбъект.ПредставлениеДокумента = ?(ДокОбъект.ПризнакТ,"Т_","")+ТекТз.ПредставлениеДокумента+"/"+ТекТз.ПредставлениеТранспорта;
				Если ДокОбъект.СтатусДокумента = 9 Тогда
					
					ДокОбъект.СтатусДокумента =0;
					
				КонецЕсли;  
				
				
				ДокОбъект.Записать();
				Если ВновьСоздан Тогда
					
					МассивДнов.Добавить(ДокОбъект.Ссылка);
					
				КонецЕсли; 
								
					
				
				Исключение
				   Сообщить(ОписаниеОшибки());
				КонецПопытки; 

			КонецЦикла; 
			ДокументыС = Документы.униНаборкаАгрегация.Выбрать(НачалоДня(ТекущаяДата()),КонецДня(ТекущаяДата()));	
			Пока ДокументыС.Следующий() цикл
				ИскСтрока = ВремТЗ.Найти(ДокументыС.Ссылка,"Ссылка");
				Если ИскСтрока = Неопределено И МассивДнов.Найти(ДокументыС.Ссылка) = Неопределено Тогда
					Попытка
				 
					ДокОбъект =  ДокументыС.Ссылка.ПолучитьОбъект();
					ДокОбъект.СтатусДокумента = 9;//заблочено
					ДокОбъект.Записать();
					Исключение
					     Сообщить(ОписаниеОшибки());
					КонецПопытки;
				КонецЕсли; 
				
				
			КонецЦикла; 
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьТекущиеДокументы();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПеречень(Команда)
	ПолучитьТекущиеДокументы();
	Элементы.Список.Обновить();
	ЭтаФорма.ОбновитьОтображениеДанных(Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
КонецПроцедуры

&НаСервере
Процедура УдалитьПрежниеДокументыНаСервере()
	ДокументыНаборки = Документы.униНаборкаАгрегация.Выбрать(Дата(1,1,1),КонецДня(ТекущаяДата()-86400));
	СчетчикОбъектов =0;
	Пока ДокументыНаборки.Следующий() Цикл
		докОбъект = ДокументыНаборки.Ссылка.ПолучитьОбъект();
		
		докОбъект.УстановитьПометкуУдаления(Истина);
		СчетчикОбъектов = СчетчикОбъектов +1;
		Если СчетчикОбъектов >= 50 Тогда
			
			Прервать;
			
		КонецЕсли; 
		
	КонецЦикла; 
	// удаление помеченных объектов с контролем ссылочной целостности
	
	Помеченные = НайтиПомеченныеНаУдаление();
	Найденные = 0;
	ПомеченныеСЛимитом = Новый Массив;   СчетчикОбъектов =0;
	Для каждого ТекМ Из Помеченные Цикл
		
		ПомеченныеСЛимитом.Добавить(ТекМ);
		СчетчикОбъектов = СчетчикОбъектов +1;
		Если СчетчикОбъектов >= 50 Тогда
			
			Прервать;
			
		КонецЕсли; 
	КонецЦикла; 
	
	УдалитьОбъекты(Помеченные, Истина, Найденные);
	Для каждого Ссылка из Найденные Цикл
		СтрСообщения = "Объект не удален: " + СокрЛП(Ссылка[0]);
		СтрСсылка = ", используется в " + СокрЛП(Ссылка[1]);
		Сообщить (СтрСообщения + СтрСсылка);
	КонецЦикла; 
	
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПрежниеДокументы(Команда)
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, Параметры);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'в ходе операции будут удалены документы до текущей даты?';"
	+ " en = 'This operation deleting documents with date less than today. Are you sure?'"), Режим, 0);
	
	
КонецПроцедуры
&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьПрежниеДокументыНаСервере();
	ОбновитьОтображениеДанных();
КонецПроцедуры



