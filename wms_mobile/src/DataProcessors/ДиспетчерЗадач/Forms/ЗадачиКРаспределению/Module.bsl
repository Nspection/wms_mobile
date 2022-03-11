
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
ОбработчикиЗапросаСервера.ОбновитьСписокЗадачКРаспределению();
СтруктураДанныхДляКлиента = новый Структура;
для Каждого Перечисления_ из Перечисления.итWMSТипыЗадачТСД цикл
	СтруктураДанныхДляКлиента.Вставить(СтрЗаменить(ТРег(Строка(Перечисления_))," ",""),Перечисления_);
КонецЦикла;
ПолеПречисленияДляКлиента=СтруктураДанныхДляКлиента;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);	
ПодключитьОбработчикОжидания("ОпросСервераБазыДанных",35,Ложь);
КонецПроцедуры

#Область ПолучениеДанныхССервера
&НаКлиенте
Процедура ОпросСервераБазыДанных() Экспорт 
//ОпросСервераБазыДанныхНаСервере()
Если ВводДоступен() Тогда 
ОпросСервераБазыДанныхНаСервереАссинхронно();
КонецЕсли;
КонецПроцедуры

&НаСервере
процедура ОпросСервераБазыДанныхНаСервереАссинхронно()
	ПараметрыМетода = новый Массив;
	СтруктураДанных=новый Структура;
	СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
	ПараметрыМетода.Добавить(СтруктураДанных);
	ФоновыеЗадания.Выполнить("ОбработчикиЗапросаСервера.ОбновитьСписокЗадачКРаспределению",ПараметрыМетода,новый УникальныйИдентификатор,"Обновить список задач к распределению");
КонецПроцедуры


#КонецОбласти


&НаКлиенте
Процедура ЗадачиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если  ТипЗнч(Элемент.ТекущаяСтрока) = тип("РегистрСведенийКлючЗаписи.итЗадачиКРаспределению") тогда
		СтандартнаяОбработка=Ложь;
		ОткрытьФорму("Обработка.ДиспетчерЗадач.Форма.ФормаВыбораДействий",новый Структура("КлючЗаписи",Текущийэлемент.ТекущаяСтрока),ЭтаФорма);
		ТригерПриемаСканераШтрихКода=Ложь;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура Отмена(Команда)
	ТекущийЭлемент=Элементы.Задачи.КоманднаяПанель;
КонецПроцедуры



&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	 Если ИмяСобытия="ОбновлениеДанныхДинамическихСписков" и Источник=ОбщийМодульКлиентскойЧасти тогда
		Элементы.Задачи.Обновить();
	 КонецЕсли;
     Если ИмяСобытия="ОбработчикШтрихКода"  и ТригерПриемаСканераШтрихКода тогда
		Если Параметр=404 и Источник="ОшибкаЧтения" тогда
			ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Штрих код некорректен");
			Возврат
		КонецЕсли;	
		ПолучитьИнформациюОЗадачахПоШтрихКоду(Параметр)
	КонецЕсли;

КонецПроцедуры
&НаКлиенте
Процедура  ПолучитьИнформациюОЗадачахПоШтрихКоду(ШтрихКод)
КлючЗаписи=ПоискИСозданиеКлючаЗаписиПоШтрихКоду(ШтрихКод);
Если КлючЗаписи=Неопределено Тогда 
	Сообщить("Задач со штрих кодом "+ШтрихКод+" не найдено");
Возврат
КонецЕсли;
//Если Найти(НРег(Строка(ВренутьЗначениеПоля(КлючЗаписи,"ТипЗадачи"))),НРег("Размещение")) тогда
Если СверитьДанныеОткрытияШтрихКодом(КлючЗаписи) тогда
 ИдЗадачиКлюча=ВренутьЗначениеПоля(КлючЗаписи,"ИдЗадачи");
 АдресДанныхОповещения=ПринятьКИсполнениюЗадачуНаСервере(КлючЗаписи);
 ОбработкаПолученныхДанныхКлиент(АдресДанныхОповещения,ИдЗадачиКлюча);
иначе
	ОткрытьФорму("Обработка.ДиспетчерЗадач.Форма.ФормаВыбораДействий",новый Структура("КлючЗаписи",КлючЗаписи),ЭтаФорма);
КонецЕсли;
ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

&НаСервереБезКонтекста	
Функция ПоискИСозданиеКлючаЗаписиПоШтрихКоду(ШтрихКод)
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	итЗадачиКРаспределению.ДокументОснование КАК ДокументОснование,
		|	итЗадачиКРаспределению.ТипЗадачи КАК ТипЗадачи,
		|	итЗадачиКРаспределению.ИдЗадачи КАК ИдЗадачи,
		|	итЗадачиКРаспределению.ИдентификаторУпаковки КАК ИдентификаторУпаковки,
		|	итЗадачиКРаспределению.Состояние КАК Состояние
		|ИЗ
		|	РегистрСведений.итЗадачиКРаспределению КАК итЗадачиКРаспределению
		|ГДЕ
		|	итЗадачиКРаспределению.ИдентификаторУпаковки = &ИдентификаторУпаковки
		|	И итЗадачиКРаспределению.Состояние = ЗНАЧЕНИЕ(Перечисление.итWMSСостоянияЗадачТСД.КВыполнению)";
	
	Запрос.УстановитьПараметр("ИдентификаторУпаковки", ШтрихКод);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда 
		КлючЗаписи=РегистрыСведений.итЗадачиКРаспределению.СоздатьКлючЗаписи(новый Структура("ДокументОснование,ТипЗадачи,ИдЗадачи",ВыборкаДетальныеЗаписи.ДокументОснование,ВыборкаДетальныеЗаписи.ТипЗадачи,ВыборкаДетальныеЗаписи.ИдЗадачи));
		Возврат КлючЗаписи;
	КонецЕсли;
	Возврат Неопределено;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
		КонецФункции
		
#Область ПринятьЗадачуНаСервереПринудительно
&НаКлиенте
Процедура ОбработкаПолученныхДанныхКлиент(ВыбранноеЗначение,ИдЗадачиКлюча)
	МассивСозданныхОбъектовДанных=Неопределено;
	ОбработкаПолученныхДанныхСервер(ВыбранноеЗначение,МассивСозданныхОбъектовДанных);
	Если  ТипЗнч(МассивСозданныхОбъектовДанных)=тип("Массив") тогда
		Если МассивСозданныхОбъектовДанных.Количество()>0 тогда
			ДанныеСканированнойЗадачи= ПолучитьКлючиДляРаботыСДанными(ИдЗадачиКлюча);
			ОткрытьФорму("Обработка.ДиспетчерЗадач.Форма.МоиЗадачиОбщийСписок",новый Структура("ДанныеСканированнойЗадачи",ДанныеСканированнойЗадачи),ЭтаФорма);
			ТригерПриемаСканераШтрихКода=Ложь;
		иначе
			Сообщить("Не каких новых данных загруженно не было");
			ЭтаФорма.Закрыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
&НаСервере
Процедура ОбработкаПолученныхДанныхСервер(ВыбранноеЗначение,МассивСозданныхОбъектовДанных)
СтруктураДанных=ПолучитьИзВременногоХранилища(ВыбранноеЗначение);
Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураДанных)тогда
	Возврат
КонецЕсли;
МодульРаспределенияДанных.ОбработчикВходящихДанных(СтруктураДанных,ВыбранноеЗначение);
ОбработчикиЗапросаСервера.ОбновитьСписокЗадачКРаспределению();
ОбработанныеДанные=ПолучитьИзВременногоХранилища(ВыбранноеЗначение);
Если ТипЗнч(ОбработанныеДанные)=тип("Структура") тогда
	Если ОбработанныеДанные.Свойство("МассивСозданныхОбъектовДанных") тогда
	МассивСозданныхОбъектовДанных=ОбработанныеДанные.МассивСозданныхОбъектовДанных;
КонецЕсли;
КонецЕсли;
	КонецПроцедуры
&НаСервере
Функция ПолучитьКлючиДляРаботыСДанными(ИдЗадачиКлюча)
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИтЗадачиНаТСД.ДокументОснование КАК ДокументОснование,
		|	ИтЗадачиНаТСД.ТипЗадачи КАК ТипЗадачи,
		|	ИтЗадачиНаТСД.ИдЗадачи КАК ИдЗадачи,
		|	ИтЗадачиНаТСД.ИдентификаторУпаковки КАК ИдентификаторУпаковки
		|ИЗ
		|	РегистрСведений.ИтЗадачиНаТСД КАК ИтЗадачиНаТСД
		|ГДЕ
		|	ИтЗадачиНаТСД.ИдЗадачи = &ИдЗадачи";
	
	Запрос.УстановитьПараметр("ИдЗадачи", ИдЗадачиКлюча);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() тогда
	СтруктураДанных=новый Структура;
	для Каждого  Колонка из РезультатЗапроса.Колонки цикл
		СтруктураДанных.Вставить(Колонка.Имя,ВыборкаДетальныеЗаписи[Колонка.Имя]);
	КонецЦикла;
	Возврат СтруктураДанных;
	КонецЕсли;
	Возврат Неопределено;
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции

&НаСервере
Функция  ПринятьКИсполнениюЗадачуНаСервере(КлючЗаписи)
УникальныйИдентификаторФормы=ЭтаФорма.УникальныйИдентификатор;
СтруктураДанных=новый Структура;
СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
СтруктураДанных.Вставить("ТипПолученияДанных","Задача");
СтруктураДанных.Вставить("КлючПолученияДанных",КлючЗаписи.ИдЗадачи);
СтруктураДанных.Вставить("ТипЗадачи",КлючЗаписи.ТипЗадачи);
Ответ=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"DataRegistrationAndDonload");
АдресДанныхОповещения=ПоместитьВоВременноеХранилище(Ответ,УникальныйИдентификаторФормы);
Возврат АдресДанныхОповещения;   	
КонецФункции
&НаСервереБезКонтекста
Функция ВренутьЗначениеПоля(Переменная,Поле)
	Возврат Переменная[Поле];
КонецФункции

&НаСервереБезКонтекста
Функция СверитьДанныеОткрытияШтрихКодом(КлючЗаписи)
	Если КлючЗаписи.ТипЗадачи=Перечисления.итWMSТипыЗадачТСД.Размещение или
		 КлючЗаписи.ТипЗадачи=Перечисления.итWMSТипыЗадачТСД.Отгрузка Тогда 
		 Возврат Истина ;
	 иначе
		 Возврат Ложь ;
	КонецЕсли;	 
	КонецФункции
#КонецОбласти
#Область ЗаконсервированныйКод
//&НаКлиенте
//Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
//	МассивСозданныхОбъектовДанных=Неопределено;
//	ОбработкаВыбораСервер(ВыбранноеЗначение,МассивСозданныхОбъектовДанных);
//	Если  ТипЗнч(МассивСозданныхОбъектовДанных)=тип("Массив") тогда
//		Если МассивСозданныхОбъектовДанных.Количество()>0 тогда
//			ОткрытьФорму("Обработка.ДиспетчерЗадач.Форма.ПолученныеЗадачи",новый Структура("МассивСозданныхОбъектовДанных",МассивСозданныхОбъектовДанных),ЭтаФорма);
//			ТригерПриемаСканераШтрихКода=Ложь;
//		иначе
//			Сообщить("Не каких новых данных загруженно не было");
//		КонецЕсли;
//	КонецЕсли;
//КонецПроцедуры
//&НаСервере
//Процедура ОбработкаВыбораСервер(ВыбранноеЗначение,МассивСозданныхОбъектовДанных)
//СтруктураДанных=ПолучитьИзВременногоХранилища(ВыбранноеЗначение);
//Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураДанных)тогда
//	Возврат
//КонецЕсли;
//МодульРаспределенияДанных.ОбработчикВходящихДанных(СтруктураДанных,ВыбранноеЗначение);
//ОбработчикиЗапросаСервера.ОбновитьСписокЗадачКРаспределению();
//ОбработанныеДанные=ПолучитьИзВременногоХранилища(ВыбранноеЗначение);
//Если ТипЗнч(ОбработанныеДанные)=тип("Структура") тогда
//	Если ОбработанныеДанные.Свойство("МассивСозданныхОбъектовДанных") тогда
//	МассивСозданныхОбъектовДанных=ОбработанныеДанные.МассивСозданныхОбъектовДанных;
//КонецЕсли;
//КонецЕсли;
//	КонецПроцедуры

#КонецОбласти