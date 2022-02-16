
// Процедура - Обработчик входящих данных
// Получает, обрабатывает, записывает, удаляет данные а так же сообщает серверу, о том какие данные уже были получены и записаны
//
// Параметры:
//  ДанныеОбработчика	 - Структура - Структура данных полученных с сервера.
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы 
//
Процедура ОбработчикВходящихДанных(ДанныеОбработчика,АдресХраненияДанных="") Экспорт 
	Если ДанныеОбработчика.Свойство("ИзмененийНет") тогда
		Если ДанныеОбработчика.ИзмененийНет тогда
			Возврат
		КонецЕсли;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		для Каждого ВидаПеречисления из Перечисления.итWMSТипыЗадачТСД цикл
			ТипОперации=СтрЗаменить(ТРег(Строка(ВидаПеречисления))," ","");
			Если ДанныеОбработчика.Свойство(ТипОперации) тогда
				Выполнить("ЗаполнениеДанных"+ТипОперации+"(ДанныеОбработчика[ТипОперации],АдресХраненияДанных)");
			КонецЕсли;
		КонецЦикла;
	Исключение
		ОтменитьТранзакцию();
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	ЗафиксироватьТранзакцию();
	СтруктураПодтвержденияЗагрузки = новый Структура;
	СтруктураПодтвержденияЗагрузки.Вставить("КлючОперации","ПодтвердитьПринятиеДанных");
	СтруктураПодтвержденияЗагрузки.Вставить("ТСДИД",ДанныеОбработчика.ТСДИД);
	СтруктураПодтвержденияЗагрузки.Вставить("НомерСообщения",ДанныеОбработчика.МаксимальныйНомерСообщений);
	ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураПодтвержденияЗагрузки,"ServiceFunction");
КонецПроцедуры

// Процедура - Заполнение данных приемка
// Получает, обрабатывает, записывает, удаляет данные - Операции типа "Приемка" 
// Параметры:
//  ДанныеОбработчика	 - Структура - Структура данных полученных с сервера.
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы 
//
Процедура ЗаполнениеДанныхПриемка(ДанныеОбработчика,АдресХраненияДанных)
	для Каждого Документ из ДанныеОбработчика цикл
		ОбработчикДанныхПриемки.ОБработатьДокументПриемка(Документ,АдресХраненияДанных);
	КонецЦикла;
КонецПроцедуры
// Процедура - Заполнение данных приемка как есть
// Получает, обрабатывает, записывает, удаляет данные - Операции типа "Приемка как есть" 
// Параметры:
//  ДанныеОбработчика	 - Структура - Структура данных полученных с сервера.
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы 
//
Процедура ЗаполнениеДанныхПриемкаКакЕсть(ДанныеОбработчика,АдресХраненияДанных)
	для Каждого Документ из ДанныеОбработчика цикл
		ОбработчикДанныхПриемки.ОБработатьДокументПриемкаКакЕсть(Документ,АдресХраненияДанных);
	КонецЦикла;	
КонецПроцедуры
// Процедура - Заполнение данных размещение
// Получает, обрабатывает, записывает, удаляет данные - Операции типа "Размещение" 
// Параметры:
//  ДанныеОбработчика	 - Структура - Структура данных полученных с сервера.
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы 
//
Процедура ЗаполнениеДанныхРазмещение(ДанныеОбработчика,АдресХраненияДанных)
	для Каждого Документ из ДанныеОбработчика цикл
		ОбработчикДанныхРазмещения.ОБработатьДокументРазмещение(Документ,АдресХраненияДанных);	
	КонецЦикла;	
КонецПроцедуры
// Процедура - Заполнение данных перемещение
// Получает, обрабатывает, записывает, удаляет данные - Операции типа "Перемещение" 
// Параметры:
//  ДанныеОбработчика	 - Структура - Структура данных полученных с сервера.
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы 
//
Процедура ЗаполнениеДанныхПеремещение(ДанныеОбработчика,АдресХраненияДанных)
	для Каждого Документ из ДанныеОбработчика цикл
		ОбработчикДанныхПеремещения.ОБработатьДокументПеремещение(Документ,АдресХраненияДанных);
	КонецЦикла;	
КонецПроцедуры
// Процедура - Заполнение данных инвентаризация
// Получает, обрабатывает, записывает, удаляет данные - Операции типа "Инвентаризация" 
// Параметры:
//  ДанныеОбработчика	 - Структура - Структура данных полученных с сервера.
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы 
//
Процедура ЗаполнениеДанныхИнвентаризация(ДанныеОбработчика,АдресХраненияДанных)
	для Каждого Документ из ДанныеОбработчика цикл
		ОбработчикДанныхЗадачИнвентаризации.ОБработатьДокументЗадачиИнвентаризации(Документ,АдресХраненияДанных);
	КонецЦикла;	
КонецПроцедуры
// Процедура - Заполнение данных наборка
// Получает, обрабатывает, записывает, удаляет данные - Операции типа "Наборка" 
// Параметры:
//  ДанныеОбработчика	 - Структура - Структура данных полученных с сервера.
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы 
//
Процедура ЗаполнениеДанныхНаборка(ДанныеОбработчика,АдресХраненияДанных)
	для Каждого Документ из ДанныеОбработчика цикл
		ОбработчикДанныхНаборки.ОБработатьДокументНаборка(Документ,АдресХраненияДанных);
	КонецЦикла;	
КонецПроцедуры
// Процедура - Заполнение данных отгрузка
// Получает, обрабатывает, записывает, удаляет данные - Операции типа "Отгрузка" 
// Параметры:
//  ДанныеОбработчика	 - Структура - Структура данных полученных с сервера.
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы 
//
Процедура ЗаполнениеДанныхОтгрузка(ДанныеОбработчика,АдресХраненияДанных)
	для Каждого Документ из ДанныеОбработчика цикл
		ОбработчикДанныхОтгрузки.ОБработатьДокументОтгрузки(Документ,АдресХраненияДанных);
	КонецЦикла;	
КонецПроцедуры
// Процедура - Заполнение данных контрольная агрегация
// Получает, обрабатывает, записывает, удаляет данные - Операции типа "КонтрольнаяАгрегация" 
// Параметры:
//  ДанныеОбработчика	 - Структура - Структура данных полученных с сервера.
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы 
//
Процедура ЗаполнениеДанныхКонтрольнаяАгрегация(ДанныеОбработчика,АдресХраненияДанных)
	для Каждого Документ из ДанныеОбработчика цикл
			ОбработчикДанныхКонтрольнойАгрегации.ОБработатьДокументКонтрольнаяАгрегация(Документ,АдресХраненияДанных);
	КонецЦикла;	
КонецПроцедуры

// Процедура - Заполнение данных проверка
// Получает, обрабатывает, записывает, удаляет данные - Операции типа "КонтрольнаяАгрегация" 
// Параметры:
//  ДанныеОбработчика	 - Структура - Структура данных полученных с сервера.
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы 
//
Процедура ЗаполнениеДанныхПроверка(ДанныеОбработчика,АдресХраненияДанных)
	для Каждого Документ из ДанныеОбработчика цикл
		ОбработчикДанныхПроверки.ОБработатьДокументПроверка(Документ,АдресХраненияДанных);
	КонецЦикла;
КонецПроцедуры

// Процедура - Заполнение данных переупаковка
// Получает, обрабатывает, записывает, удаляет данные - Операции типа "КонтрольнаяАгрегация" 
// Параметры:
//  ДанныеОбработчика	 - Структура - Структура данных полученных с сервера.
//  АдресХраненияДанных	 - Строка - адрес временного хранилища или адрес Временного хранилища формы, получаемого методом СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы 
//
Процедура ЗаполнениеДанныхПереупаковка(ДанныеОбработчика,АдресХраненияДанных)
	КонецПроцедуры


// Процедура - Синхронизовать справочные данные
// Синхронизует данные справочников Сервера и клиента , где сервер - 1с на ПК.
Процедура СинхронизоватьСправочныеДанные() Экспорт 
ДанныеОбработчика=новый Структура;
ДанныеОбработчика.Вставить("КлючОперации","СинхронизацияСправочныхДанных");
ДанныеОбработчика=ОбработчикиЗапросаСервера.ЗапроситьДанные(ДанныеОбработчика,"ServiceFunction");
Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(ДанныеОбработчика) Тогда 
	Возврат
КонецЕсли;

Для Каждого Справочник из ДанныеОбработчика цикл
	Если Справочник.Ключ="КлючОперации" Тогда 
		Продолжить;
	КонецЕсли;
	Выполнить("ОбработчикДанныхОбщиеФункцииИПроцедуры."+"ОбработкаСправочника_"+Справочник.Ключ+"(ДанныеОбработчика[Справочник.Ключ])");
КонецЦикла;

КонецПроцедуры