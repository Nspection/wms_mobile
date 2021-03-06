
&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Строка=ТекущийЭлемент.ТекущиеДанные;
	КлючЗаписи=ПоискИСозданиеКлючаЗаписиПоИдЗадачи(Строка.ИдЗадачи);
	Если КлючЗаписи=Неопределено Тогда 
		Сообщить("задача не найдена");
		Возврат
	КонецЕсли;	
	ОткрытьФорму("Обработка.ДиспетчерЗадач.Форма.ФормаВыбораДействий",новый Структура("КлючЗаписи",КлючЗаписи),ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
	Возврат

КонецПроцедуры
&НаСервереБезКонтекста	
Функция ПоискИСозданиеКлючаЗаписиПоИдЗадачи(Знач ИдЗадачи)
	Если ТипЗнч(ИдЗадачи)=Тип("Строка") Тогда 
		ИдЗадачи=новый УникальныйИдентификатор(ИдЗадачи);
	КонецЕсли;	
	
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
	|	итЗадачиКРаспределению.Состояние = ЗНАЧЕНИЕ(Перечисление.итWMSСостоянияЗадачТСД.КВыполнению)
	|	И итЗадачиКРаспределению.ИдЗадачи = &ИдЗадачи";
	
	Запрос.УстановитьПараметр("ИдЗадачи", ИдЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда 
		КлючЗаписи=РегистрыСведений.итЗадачиКРаспределению.СоздатьКлючЗаписи(новый Структура("ДокументОснование,ТипЗадачи,ИдЗадачи",ВыборкаДетальныеЗаписи.ДокументОснование,ВыборкаДетальныеЗаписи.ТипЗадачи,ВыборкаДетальныеЗаписи.ИдЗадачи));
		Возврат КлючЗаписи;
	КонецЕсли;
	Возврат Неопределено;
	
	
КонецФункции
	
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
Процедура ОбработчкаПолученияДанныхШтрихКода(Параметр)
	 КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДокументОснование=Неопределено;
	Параметры.Свойство("ДокументОснование",ДокументОснование);
	Список.Параметры.УстановитьЗначениеПараметра("ДокументОснование",ДокументОснование);
 КонецПроцедуры

&НаСервереБезКонтекста
 Процедура ОбновитьНаСервере()
	СтруктураДанных=новый Структура;
	СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
	СтруктураДанных.Вставить("ТипЗадачи",Перечисления.итWMSТипыЗадачТСД.Наборка);
	ОбработчикиЗапросаСервера.ОбновитьСписокЗадачКРаспределению(СтруктураДанных);
 КонецПроцедуры

&НаКлиенте
 Процедура Обновить(Команда)
	 ОбновитьНаСервере();
	 Элементы.Список.Обновить();
 КонецПроцедуры
