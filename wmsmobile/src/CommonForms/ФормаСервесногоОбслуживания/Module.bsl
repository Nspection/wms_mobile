#Область ОбработчикиСобытий
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьБазуДанных(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаОчисткаБд");
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

&НаСервере
Процедура СинхронизацияСправочныхДанныхНаСервере()
	МодульРаспределенияДанных.СинхронизоватьСправочныеДанные();
КонецПроцедуры

&НаКлиенте
Процедура СинхронизацияСправочныхДанных(Команда)
	Попытка
		СинхронизацияСправочныхДанныхНаСервере();
	Исключение
		Сообщить("Произошла ошибка");
	КонецПопытки;
	Сообщить("Данные синхронизированы");
КонецПроцедуры


&НаКлиенте
Процедура ВосстановитьПотерянныеДанные(Команда)
	Попытка
		ВосстановитьПотерянныеДанныеНаСервере();
	Исключение
		Сообщить("Ошибка восстановления данных");
	КонецПопытки;
	Сообщить("Данные восстановленны");
КонецПроцедуры
&НаСервере
Процедура ВосстановитьПотерянныеДанныеНаСервере()
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИтЗадачиНаТСД.ИдЗадачи КАК ИдЗадачи
	|ИЗ
	|	РегистрСведений.ИтЗадачиНаТСД КАК ИтЗадачиНаТСД
	|
	|СГРУППИРОВАТЬ ПО
	|	ИтЗадачиНаТСД.ИдЗадачи";
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	МассивЗадачНаТСД= РезультатЗапроса.ВыгрузитьКолонку("ИдЗадачи");
	
	ДанныеОбработчика=новый Структура;
	СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(ДанныеОбработчика);
	ДанныеОбработчика.Вставить("МассивЗадачНаТСД",МассивЗадачНаТСД);
	ДанныеОбработчика.Вставить("КлючОперации","ВосстановитьПотерянныеДанные");
	ДанныеОбработчика=ОбработчикиЗапросаСервера.ЗапроситьДанные(ДанныеОбработчика,"ServiceFunction");
	Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(ДанныеОбработчика) Тогда
		Сообщить(ДанныеОбработчика.ОписаниеОшибки);
		Возврат
	КонецЕсли;
	Адрес=ПоместитьВоВременноеХранилище("",ЭтаФорма.УникальныйИдентификатор);
	МодульРаспределенияДанных.ОбработчикВходящихДанных(ДанныеОбработчика,Адрес);
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьДрайверКлавиатуры(Команда)
	МодульМобильныхДивайсовКлиент.ЗапуститьУстановкуДрайвераКлавиатуры();
КонецПроцедуры


&НаКлиенте
Процедура НастройкиПолученияПМУ(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаНастроекПолученияПМУУчета",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры




&НаКлиенте
Процедура ОтправитьЛогНаСервер(Команда)
	СлужебныеФункцииИПроцедурыКлиентСервер.ОтправитьЛогНаСервер();
КонецПроцедуры


&НаКлиенте
Процедура УдалитьСтарыеИзмененияНаТСД(Команда)
	СлужебныеФункцииИПроцедурыКлиентСервер.УдалениеРегистрацииТСД();
КонецПроцедуры
#КонецОбласти
