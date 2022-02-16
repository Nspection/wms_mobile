
#Область ОбработчикиСобытий
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.ОбъектДанных.Пустая() тогда
		Отказ=Истина;
		Сообщить("Не верный формат данных");
	КонецЕсли;
	ОбъектДанных=Параметры.ОбъектДанных;
	//ТипЗадачи=ОбъектДанных.ТипЗадачи;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если не НеВозвращатьКонтрольНадТригером тогда
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
		СчитанныйSSCC=Параметр;
		ПрименитьКДокументу();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд
&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры
&НаКлиенте
Процедура ПрименитьКДокументу()
	Если ЗначениеЗаполнено(СчитанныйSSCC) тогда
		Отказ=Ложь;
		ОбщийМодульКлиентскойЧасти.ПроверитьSSCCНаЛеквидность(СчитанныйSSCC,Отказ);
		Если Отказ тогда
			Сообщить("текущий штрих код не соответствует нормам SSCC");
			Возврат
		КонецЕсли;	
		ПрисвоитьВнешнийSSCCНаСервере(СчитанныйSSCC,Отказ);
		Если Отказ тогда
			Возврат
		КонецЕсли;
		ОбработкаПолученияДанныхШтрихКода(СчитанныйSSCC);
		ЭтаФорма.Закрыть();
		//ОповеститьОВыборе(СчитанныйSSCC);
	иначе
		ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Вы не считали ни какого штрих-кода");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ПрисвоитьВнешнийSSCCНаСервере(SSCC,Отказ)
	ОбъектДанныхОбъект=ОбъектДанных.ПолучитьОбъект();
	Строки=ОбъектДанныхОбъект.ДанныеАгрегации.НайтиСтроки(новый Структура("SSCC",SSCC));
	Если Строки.Количество()>0 Тогда
		Сообщить("SSCC уже внесен в базу");
		Отказ=Истина;
		Возврат;
	КонецЕсли;
	НоваяСтрока=ОбъектДанныхОбъект.ДанныеАгрегации.Добавить();
	НоваяСтрока.SSCC=SSCC;
	ОбъектДанныхОбъект.Записать();
КонецПроцедуры
&НаКлиенте
Процедура ОбработкаПолученияДанныхШтрихКода(ШтрихКод)
ОткрытьФорму("Документ.итДокументСвободнойАгрегации.Форма.ФормаSSCC",новый Структура("ОбъектДанных,SSCC",ОбъектДанных,ШтрихКод),ЭтаФорма.ВладелецФормы);
ТригерПриемаСканераШтрихКода=Ложь;
НеВозвращатьКонтрольНадТригером=Истина;
КонецПроцедуры

&НаСервере
Функция ИнфорацияОСтатусеДокумента()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ИтЗадачиНаТСД.Состояние = ЗНАЧЕНИЕ(Перечисление.итWMSСостоянияЗадачТСД.Выполнена)
	|					ИЛИ ИтЗадачиНаТСД.Состояние = ЗНАЧЕНИЕ(Перечисление.итWMSСостоянияЗадачТСД.Выполняется)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Статус
	|ИЗ
	|	РегистрСведений.ИтЗадачиНаТСД КАК ИтЗадачиНаТСД
	|ГДЕ
	|	ИтЗадачиНаТСД.ДокументОснование = &ДокументОснование
	|	И ИтЗадачиНаТСД.ТипЗадачи = &ТипЗадачи";
	
	Запрос.УстановитьПараметр("ДокументОснование", ОбъектДанных.Ссылка);
	Запрос.УстановитьПараметр("ТипЗадачи", ОбъектДанных.ТипЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() тогда
		Если  ВыборкаДетальныеЗаписи.Статус=1 тогда
			Возврат Истина;
		иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	Возврат Ложь;
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции

#КонецОбласти