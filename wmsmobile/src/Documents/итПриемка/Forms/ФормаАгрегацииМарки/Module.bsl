
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не ТипЗнч(Параметры.ДанныеМарки) = тип("Структура") тогда
		Отказ=Истина;
		Возврат
	КонецЕсли;
	Если не Параметры.ДанныеМарки.Свойство("Марка") тогда
		Отказ=Истина;
		Возврат
	КонецЕсли;
	Марка=Параметры.ДанныеМарки.Марка;
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
		Gtin=ШтрихКод;
		Параметры.ДанныеМарки.Вставить("GTINАгрегации",ШтрихКод);
		ОповеститьОВыборе(Параметры.ДанныеМарки);
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
Процедура ОбработчикSSCC(ШтрихКод,ШтрихКодОбработан)
	ТаблицаДанныхДобавления=Неопределено;
	SSCCБезКонтрольнойЦифры=Лев(ШтрихКод,СтрДлина(ШтрихКод)-1);
	КонтрольнаяЦифраВSSCC=Прав(ШтрихКод,1);
	ДанныеРасчетаКонтрольнойЦифры=ПолучитьКонтрольнуюЦифруШтрихКода(SSCCБезКонтрольнойЦифры);
	Если  СокрЛП(НРег(КонтрольнаяЦифраВSSCC))=СокрЛП(НРег(ДанныеРасчетаКонтрольнойЦифры)) тогда
	ШтрихКодОбработан=Истина;	
	КонецЕсли;	
	КонецПроцедуры
&НаСервере	
Функция ПолучитьКонтрольнуюЦифруШтрихКода(ШтрихКод)Экспорт
	ДлинаШтрихКода=СтрДлина(ШтрихКод);
	СуммаНеЧетных=ПолучитьСуммуЦифрНаНечетныхМестах(ДлинаШтрихКода,ШтрихКод);
	СуммаЧетных=ПосчитатьСуммуЦифрНаЧетныхМестах(ДлинаШтрихКода,ШтрихКод);
	СтрокаИтого=Строка(СуммаНеЧетных+СуммаЧетных);
	ЕденицаСуммы=Прав(СтрокаИтого,1);
	Если Число(ЕденицаСуммы) = 0 тогда
		Возврат "0" 
	иначе
		Возврат Строка(10-Число(ЕденицаСуммы));
	КонецЕсли;	
КонецФункции
&НаСервере
Функция ПосчитатьСуммуЦифрНаЧетныхМестах(ДлинаШтрихКода,ШтрихКод)
	Если ДлинаШтрихКода<2 тогда
		Возврат 0
	КонецЕсли;
	Сумма=0;
	ТочкаОтсчета=ДлинаШтрихКода;
	Если  Окр(ДлинаШтрихКода/2,0,РежимОкругления.Окр15как20) <> ДлинаШтрихКода/2 тогда
		ЧетноеКоличествоСимволов=Ложь;
	иначе
		ЧетноеКоличествоСимволов=Истина;
	КонецЕсли;	
	
	для n=1 по ДлинаШтрихКода цикл
		Если ТочкаОтсчета-n=0 и не ЧетноеКоличествоСимволов Тогда 
			Прервать;
		КонецЕсли;	
		Сумма=Сумма+Число(Сред(ШтрихКод,ТочкаОтсчета-n,1));
		Если (n+1)>ДлинаШтрихКода тогда
			Прервать;
		КонецЕсли;		
		n=n+1;
	КонецЦикла;
	
	Возврат Сумма;
	
КонецФункции
&НаСервере	
Функция ПолучитьСуммуЦифрНаНечетныхМестах(ДлинаШтрихКода,ШтрихКод)
	Сумма=0;
	ТочкаОтсчета=ДлинаШтрихКода+1;
	Если  Окр(ДлинаШтрихКода/2,0,РежимОкругления.Окр15как20) <> ДлинаШтрихКода/2 тогда
		ЧетноеКоличествоСимволов=Ложь;
	иначе
		ЧетноеКоличествоСимволов=Истина;
	КонецЕсли;	

	для n=1 по ДлинаШтрихКода цикл
		Если ТочкаОтсчета-n=0 и  ЧетноеКоличествоСимволов Тогда 
			Прервать;
		КонецЕсли;
		Сумма=Сумма+Число(Сред(ШтрихКод,ТочкаОтсчета-n,1));
		Если (n+1)>ДлинаШтрихКода тогда
			Прервать;
		КонецЕсли;	
		n=n+1;
	КонецЦикла;
	Сумма=Сумма*3;
	Возврат Сумма;
КонецФункции


&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры
