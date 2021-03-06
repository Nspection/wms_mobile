// Процедура - О бработать документ наборка
//
// Параметры:
//  Документ			 - Структура - структура содержащая в себе данные документа на сервере 
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы
//
Процедура ОБработатьДокументНаборка(Документ,АдресХраненияДанных="")Экспорт 
ТипОбрабатываемойЗадачи=Перечисления.итWMSТипыЗадачТСД.Наборка;
////СлужебныеФункцииИПроцедурыКлиентСервер.ДобавитьВЛог(,"#ОбработчикДанныхНаборки Поиск создание документа наборки",Документ.ГУИД);
ДокументТСД=НайтиСоздатьДокументНаборки(Документ,ТипОбрабатываемойЗадачи,АдресХраненияДанных);
Если не Документ.Свойство("МассивЗадач") тогда
	ВызватьИсключение "Ошибка типа данных";
КонецЕсли;

Если ТипЗнч(Документ.ДополнительныеДанные)=тип("Структура") тогда
	ОбъектДокументаТСД=Неопределено;	
	Если  Документ.ДополнительныеДанные.Свойство("ДанныеШтрихКодовЯчеекДокумента") тогда
		Если ОбъектДокументаТСД=Неопределено Тогда 
			ОбъектДокументаТСД=ДокументТСД.ПолучитьОбъект();
		КонецЕсли;
		ДанныеШтрихКодовЯчеекДокумента= Документ.ДополнительныеДанные.ДанныеШтрихКодовЯчеекДокумента;
		ОбъектДокументаТСД.ШтрихКодыЯчеекДокумента.Очистить();
		для Каждого стр из  ДанныеШтрихКодовЯчеекДокумента цикл
			НоваяСтрокаДополнительныхДанных=ОбъектДокументаТСД.ШтрихКодыЯчеекДокумента.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДополнительныхДанных,стр);
		КонецЦикла;
		
	КонецЕсли;
	Если  Документ.ДополнительныеДанные.Свойство("ЗаказНаборки") Тогда
		Если ОбъектДокументаТСД=Неопределено Тогда 
			ОбъектДокументаТСД=ДокументТСД.ПолучитьОбъект();
		КонецЕсли;
		ОбъектДокументаТСД.ЗаказНаборки=  Документ.ДополнительныеДанные.ЗаказНаборки;
	КонецЕсли;
	Если  Документ.ДополнительныеДанные.Свойство("Маршрут") Тогда
		Если ОбъектДокументаТСД=Неопределено Тогда 
			ОбъектДокументаТСД=ДокументТСД.ПолучитьОбъект();
		КонецЕсли;
		ОбъектДокументаТСД.Маршрут=  Документ.ДополнительныеДанные.Маршрут;
	КонецЕсли;
	Если  Документ.ДополнительныеДанные.Свойство("ПредставлениеМаршрута") Тогда
		Если ОбъектДокументаТСД=Неопределено Тогда 
			ОбъектДокументаТСД=ДокументТСД.ПолучитьОбъект();
		КонецЕсли;
		ОбъектДокументаТСД.МаршрутПредставление =  Документ.ДополнительныеДанные.ПредставлениеМаршрута;
	КонецЕсли;
	Если  Документ.ДополнительныеДанные.Свойство("ОчередьДоставки") Тогда
		Если ОбъектДокументаТСД=Неопределено Тогда 
			ОбъектДокументаТСД=ДокументТСД.ПолучитьОбъект();
		КонецЕсли;
		ОбъектДокументаТСД.ОчередьДоставки=  Документ.ДополнительныеДанные.ОчередьДоставки;
	КонецЕсли;
	Если  Документ.ДополнительныеДанные.Свойство("ВесНаборки") Тогда
		Если ОбъектДокументаТСД=Неопределено Тогда 
			ОбъектДокументаТСД=ДокументТСД.ПолучитьОбъект();
		КонецЕсли;
		ОбъектДокументаТСД.ВесНаборки=  Документ.ДополнительныеДанные.ВесНаборки;
	КонецЕсли;

    Если  Документ.ДополнительныеДанные.Свойство("FSRARID") Тогда
		Если ОбъектДокументаТСД=Неопределено Тогда 
			ОбъектДокументаТСД=ДокументТСД.ПолучитьОбъект();
		КонецЕсли;
		ОбъектДокументаТСД.FSRARID=  Документ.ДополнительныеДанные.FSRARID;
	КонецЕсли;
	Если  Документ.ДополнительныеДанные.Свойство("РозничныйКА") Тогда
		Если ОбъектДокументаТСД=Неопределено Тогда 
			ОбъектДокументаТСД=ДокументТСД.ПолучитьОбъект();
		КонецЕсли;
		ОбъектДокументаТСД.РозничныйПризнак=  Документ.ДополнительныеДанные.РозничныйКА;
	КонецЕсли;

	Если ОбъектДокументаТСД <> Неопределено Тогда 
		ОбъектДокументаТСД.Записать();
	КонецЕсли;		
КонецЕсли;
СтруктураТиповыхПараметровЗадач=ОбработчикДанныхОбщиеФункцииИПроцедуры.СформироватьТиповуюСтруктуруПараметровДанныхЗадач(,ДокументТСД,ТипОбрабатываемойЗадачи,АдресХраненияДанных);
Если Документ.Свойство("ПомарочныйУчет")  Тогда
	СтруктураТиповыхПараметровЗадач.ЗапроситьДанныеМарок=Документ.ПомарочныйУчет
иначе
	СтруктураТиповыхПараметровЗадач.ЗапроситьДанныеМарок=Ложь;
КонецЕсли;

для Каждого Задача из Документ.МассивЗадач цикл
	СтруктураТиповыхПараметровЗадач.Задача=Задача;
	ОбработчикДанныхОбщиеФункцииИПроцедуры.ОбработчикСозданиеИзменениеУдалениеЗадач(СтруктураТиповыхПараметровЗадач);
КонецЦикла;
////СлужебныеФункцииИПроцедурыКлиентСервер.ДобавитьВЛог(,"+#ОбработчикДанныхНаборки Запрос марок , если они есть к наборке. Количество задач:"+СтруктураТиповыхПараметровЗадач.МассивИдЗадачПомарочногоУчета.Количество(),Документ.ГУИД);
Если СтруктураТиповыхПараметровЗадач.ЗапроситьДанныеМарок  Тогда
	ОбработчикДанныхОбщиеФункцииИПроцедуры.ПолучитьДанныеМарокПоСпискуЗадач(СтруктураТиповыхПараметровЗадач.МассивИдЗадачПомарочногоУчета,СтруктураТиповыхПараметровЗадач.ТипОбрабатываемойЗадачи);
КонецЕсли;
////СлужебныеФункцииИПроцедурыКлиентСервер.ДобавитьВЛог(,"-#ОбработчикДанныхНаборки окончание запроса мрок",Документ.ГУИД);
ОбработчикДанныхОбщиеФункцииИПроцедуры.ПроверитьУдалитьДокумент(ДокументТСД,АдресХраненияДанных);

КонецПроцедуры


#Область СлужебныеФункцииИпроцедурыПриемки
Функция НайтиСоздатьДокументНаборки(Документ,ТипЗадачи,АдресХраненияДанных="")
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	итНаборка.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.итНаборка КАК итНаборка
		|ГДЕ
		|	итНаборка.ГУИД = &ГУИД";
	
	Запрос.УстановитьПараметр("ГУИД", Документ.ГУИД);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() тогда
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	иначе
		НовыйДокументНаборки = Документы.итНаборка.СоздатьДокумент();
		НовыйДокументНаборки.ГУИД=Документ.ГУИД;
		НовыйДокументНаборки.Номер=Документ.Номер;
		НовыйДокументНаборки.Дата=Документ.Дата;
		НовыйДокументНаборки.ТипЗадачи=ТипЗадачи;
		//Если ТипЗнч(Документ.ДополнительныеДанные)=Тип("Массив") тогда
		//	для Каждого стр из Документ.ДополнительныеДанные цикл
		//		НоваяСтрокаФизическихДанных=НовыйДокументПриемки.ДанныеФизическогоНосителя.Добавить();
		//		ЗаполнитьЗначенияСвойств(НоваяСтрокаФизическихДанных,стр);
		//		
		//	КонецЦикла;
		//КонецЕсли;
		НовыйДокументНаборки.Записать();
		Если ЗначениеЗаполнено(АдресХраненияДанных) тогда
		ОбработчикДанныхОбщиеФункцииИПроцедуры.РаботаСВременнымХранилищемМассивИзменений(АдресХраненияДанных,"Создан",НовыйДокументНаборки.Ссылка);
		КонецЕсли;
		Возврат НовыйДокументНаборки.Ссылка;
	КонецЕсли;	
			
		//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
	КонецФункции
#КонецОбласти