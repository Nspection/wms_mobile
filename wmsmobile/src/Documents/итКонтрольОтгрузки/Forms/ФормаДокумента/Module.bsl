
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
 УстановитьКоличественныеДанныеСканирования();
 УстановитьТекстХелпера();
 ВидимостьДоступностьЭлементов();
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
		 ОбработчкаПолученияДанныхШтрихКода(Параметр);
	 КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд
&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаСервере
Процедура ОтказатьсяНаСервере()
	ОбъектИзменения=Объект.Ссылка.ПолучитьОбъект();
	ОбъектИзменения.Удалить();
КонецПроцедуры

&НаКлиенте
Процедура Отказаться(Команда)
	Оповещение= новый ОписаниеОповещения("Отказатьсяоповещение",ЭтаФорма);
	ПоказатьВопрос(Оповещение,"Вы точно хотите отказаться от контроля отгрузки?",РежимДиалогаВопрос.ДаНет);
КонецПроцедуры
&НаКлиенте
Процедура Отказатьсяоповещение(Результат,Параметры) Экспорт 
	Если Результат=КодВозвратаДиалога.Нет Тогда 
		Возврат
	КонецЕсли;
	ОтказатьсяНаСервере();
	ОповеститьОВыборе("");
КонецПроцедуры
&НаКлиенте
Процедура Заврешить(Команда)
	Оповещение= новый ОписаниеОповещения("ЗаврешитьОповещение",ЭтаФорма);
	ДопСообщение="";
	Если РежимСканированияПоSSCC() Тогда
		Если НеобходимоОтсканировать<>Отсканированно Тогда 
			ДопСообщение="Вы отсканировали не все паллеты!!! ";
		КонецЕсли;	
	КонецЕсли;	
	ПоказатьВопрос(Оповещение,ДопСообщение+"Вы точно хотите завершить  контроль отгрузки?",РежимДиалогаВопрос.ДаНет);
КонецПроцедуры
&НаКлиенте
Процедура ЗаврешитьОповещение(Результат,Параметры) Экспорт 
	Если Результат=КодВозвратаДиалога.Нет Тогда 
		Возврат
	КонецЕсли;
	ОтказатьсяНаСервере();
	ОповеститьОВыборе("");
	КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ВидимостьДоступностьЭлементовКлиент()
	ВидимостьДоступностьЭлементов();
КонецПроцедуры
&НаСервере
Процедура ВидимостьДоступностьЭлементов()
	Если не ДанныеУстановлены Тогда 
		Элементы.НеобходимоОтсканировать.Видимость=Ложь;
		Элементы.Отсканировано.Видимость=Ложь;
		Элементы.ПаллетыКОтгрузке.Видимость=Ложь;
	КонецЕсли;
	Если РежимСканированияПоSSCC()   Тогда 
		Элементы.НеобходимоОтсканировать.Видимость=Истина;
		Элементы.Отсканировано.Видимость=Истина;
		Элементы.ПаллетыКОтгрузке.Видимость=Истина;
	КонецЕсли;
	Если РежимСканированияПоКлючу() Тогда 
		Элементы.Отсканировано.Видимость=Истина;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстХелпера()
	Если Объект.ДатаНакладной='00010101' или Объект.НомерНакладной="" Тогда 
		 Элементы.хелпер.Заголовок="Заполните дату и номер накладной!";
		 Возврат
	КонецЕсли;	 
	Если не ДанныеУстановлены Тогда 
		Элементы.хелпер.Заголовок="Сканируйте ШК Задачи";
		Возврат
	КонецЕсли;
	Если РежимСканированияПоSSCC()  и Отсканированно<НеобходимоОтсканировать Тогда 
	     Элементы.хелпер.Заголовок="Сканируйте SSCC";
		 Возврат;
	 КонецЕсли;	
	 	Если РежимСканированияПоSSCC()  и Отсканированно=НеобходимоОтсканировать Тогда 
	     Элементы.хелпер.Заголовок="Контроль выполнен полностью, вы можете завершить операцию";
		 Возврат;
	КонецЕсли;	

	Если РежимСканированияПоКлючу()   и   НеобходимоОтсканировать=0  Тогда 
	     Элементы.хелпер.Заголовок="Сканируйте вспомогательный ШК на 
		 |паллете или завершите отгрузку";
		 Возврат;
	КонецЕсли;	 

	
КонецПроцедуры
&НаСервере
Процедура  РассчитатьКоличествоОтсканированных()
Отсканированно= 0;
Для Каждого стр из Объект.ПаллетыКОтгрузке цикл
	Если стр.Отгружено Тогда 
		Отсканированно=Отсканированно+1;
	КонецЕсли;
Элементы.Отсканировано.Заголовок="Отсканировано:"+Отсканированно;
КонецЦикла;
КонецПроцедуры
&НаКлиенте
Процедура ОбработчкаПолученияДанныхШтрихКода(Параметр)
	Если  Элементы.хелпер.Заголовок="Контроль выполнен полностью, вы можете завершить операцию" Тогда 
		Возврат
	КонецЕсли;	
	Если  Элементы.хелпер.Заголовок="Заполните дату и номер накладной!" Тогда 
		 ЗаполнитьДанныеНакладнойПоШк(Параметр);	
		Возврат
	КонецЕсли;	
	Если ДанныеУстановлены Тогда 
	    ОбработкаСканированияДанныхКонтроля(Параметр);
	иначе
		УстановитьДанныеКСканированию(Параметр);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаСканированияДанныхКонтроля(Параметр)
	Если РежимСканированияПоКлючу() Тогда 
		ОбработкаСканированияДанныхКонтроляПоКлючу(Параметр);
	КонецЕсли;
	Если РежимСканированияПоSSCC() Тогда 
		ОбработкаСканированияДанныхКонтроляSSCC(Параметр);
	КонецЕсли;
	РассчитатьКоличествоОтсканированных();
	ВидимостьДоступностьЭлементовКлиент();
	ЭтаФорма.Записать();
КонецПроцедуры
&НаСервере
Процедура ОбработкаСканированияДанныхКонтроляПоКлючу(Параметр)
	Если СокрЛП(Параметр)<>Объект.ШкОтгрузки Тогда 
		Сообщить("не верный ключ паллеты");
		Возврат;
	КонецЕсли;	
	НоваяСтрока=Объект.ПаллетыКОтгрузке.Добавить();
	НоваяСтрока.ИдентификаторУпаковки=Объект.ПаллетыКОтгрузке.Количество();
	НоваяСтрока.Отгружено=Истина;
КонецПроцедуры
&НаСервере
Процедура ОбработкаСканированияДанныхКонтроляSSCC(Параметр)
    Строки=Объект.ПаллетыКОтгрузке.НайтиСтроки(новый Структура("ИдентификаторУпаковки",СокрЛП(Параметр)));	
	Если Строки.Количество()=0 Тогда 
		Сообщить("Текущего SSCC в данных текущей отгрузки нет");
		Возврат;
	КонецЕсли;
	Для Каждого СтрокаСписка из Строки цикл
		СтрокаСписка.Отгружено=Истина;
	КонецЦикла;
КонецПроцедуры



&НаСервере
Процедура УстановитьДанныеКСканированию(Параметр)
	Если   Найти(Параметр,"SSCCКСКАНИРОВАНИЮ:")> 0 Тогда 
		 УстановитьДанныеSSCC(Параметр);
		 ВидимостьДоступностьЭлементов();
		 ЭтаФорма.Записать();
		Возврат;
	КонецЕсли;
	Если   Найти(Параметр,"КЛЮЧСКАНИРОВАНИЯ:")> 0 Тогда 
		УстановитьДанныеКлючаСканирования(Параметр);
		ВидимостьДоступностьЭлементов();
		ЭтаФорма.Записать();
    	Возврат;
	КонецЕсли;
    Сообщить("Шк получения данных некорректен!!!");
КонецПроцедуры
&НаСервере
Процедура УстановитьДанныеSSCC(Параметр)
	СтрокаЧтения=СтрЗаменить(Параметр,"SSCCКСКАНИРОВАНИЮ:","");
	МассивSSCC=СлужебныеФункцииИПроцедурыКлиентСервер.Split(СтрокаЧтения,";");
	Объект.ПаллетыКОтгрузке.Очистить();
	Для Каждого стр из МассивSSCC цикл
		НоваяСтрока= Объект.ПаллетыКОтгрузке.Добавить();
		НоваяСтрока.ИдентификаторУпаковки=стр;
		НеобходимоОтсканировать=НеобходимоОтсканировать+1;
	КонецЦикла;
	Элементы.НеобходимоОтсканировать.Заголовок="Необходимо отсканировать:"+НеобходимоОтсканировать;
	ДанныеУстановлены=Истина;
КонецПроцедуры
&НаСервере
Процедура УстановитьДанныеКлючаСканирования(Параметр)
	СтрокаЧтения=СтрЗаменить(Параметр,"КЛЮЧСКАНИРОВАНИЯ:","");
	Объект.ШкОтгрузки=СтрокаЧтения;
	Элементы.Отсканировано.Заголовок="Отсканировано:"+Отсканированно;
КонецПроцедуры

&НаСервере
Процедура УстановитьКоличественныеДанныеСканирования()
РассчитатьКоличествоОтсканированных();
Элементы.Отсканировано.Заголовок="Отсканировано:"+Отсканированно;
Если не РежимСканированияПоКлючу() Тогда 
	НеобходимоОтсканировать=Объект.ПаллетыКОтгрузке.Количество();
КонецЕсли;
Элементы.НеобходимоОтсканировать.Заголовок="Необходимо отсканировать:"+НеобходимоОтсканировать;
Если РежимСканированияПоКлючу() или  РежимСканированияПоSSCC()>0 Тогда 
	ДанныеУстановлены=Истина;
КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция РежимСканированияПоКлючу()
	Если  Объект.ШкОтгрузки<>"" Тогда 
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции
&НаСервере
Функция РежимСканированияПоSSCC()
	Если  НеобходимоОтсканировать>0 Тогда 
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции
&НаСервере
Процедура ЗаполнитьДанныеНакладнойПоШк(Параметр)
Если   Найти(Параметр,"KeyDocument:")> 0 Тогда 
		СтрокаЧтения=СтрЗаменить(Параметр,"KeyDocument:","");
        МассивДанных=СлужебныеФункцииИПроцедурыКлиентСервер.Split(СтрокаЧтения,";");
		Если МассивДанных.Количество()<> 3 Тогда 
			Возврат
		КонецЕсли;
	    МассивДаты=СлужебныеФункцииИПроцедурыКлиентСервер.Split(МассивДанных[0],".");
        Если МассивДаты.Количество()<> 3 Тогда 
			Возврат
		КонецЕсли;
		СтрокаДаты=МассивДаты[2]+МассивДаты[1]+МассивДаты[0];
		Объект.ДатаНакладной=Дата(СтрокаДаты);
		Объект.НомерНакладной=МассивДанных[1];
		Объект.КлючНакладной=МассивДанных[2];
		ЭтаФорма.Записать();
		УстановитьТекстХелпера();
КонецЕсли;	
	КонецПроцедуры



#КонецОбласти
