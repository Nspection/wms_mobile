#Область ОбработчикиСобытий
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не Параметры.Свойство("ИдЗадачи") Тогда 
		Отказ=Истина;
		Возврат
	КонецЕсли;	
	ИдЗадачи=Параметры.ИдЗадачи;
    ЗаполнитьДаннымиЗадачи(Отказ);	
	СписокВыбораПричнОтмены();
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
Если ИмяСобытия = "ОбработчикШтрихКода" и ТригерПриемаСканераШтрихКода тогда
	Если Параметр = 404 и Источник = "ОшибкаЧтения" тогда
		ОбщийМодульКлиентскойЧасти.СообщитьЧерезФорму("Штрих код некорректен");
		Возврат
	КонецЕсли;
	ОбработчкаПолученияДанныхШтрихКода(Параметр);
КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеЗадачиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		СтандартнаяОбработка=Ложь;
		СтруктураПараметров=новый Структура;
		СтруктураПараметров.Вставить("Номенклатура",ТекущийЭлемент.ТекущиеДанные.Номенклатура);
		СтруктураПараметров.Вставить("НоменклатураПредставление",ТекущийЭлемент.ТекущиеДанные.НоменклатураПредставление);
        СтруктураПараметров.Вставить("СерияНоменклатуры",ТекущийЭлемент.ТекущиеДанные.СерияНоменклатуры);
        СтруктураПараметров.Вставить("СерияНоменклатурыПредставление",ТекущийЭлемент.ТекущиеДанные.СерияНоменклатурыПредставление);
		СтруктураПараметров.Вставить("ИдСтроки",ТекущийЭлемент.ТекущиеДанные.ИдСтроки);
        СтруктураПараметров.Вставить("ПомарочныйУчет",ТекущийЭлемент.ТекущиеДанные.ПомарочныйУчет);
		СтруктураПараметров.Вставить("ШтрихкодКороба",ТекущийЭлемент.ТекущиеДанные.ШтрихкодКороба);
        СтруктураПараметров.Вставить("КоэффициентКороба",ТекущийЭлемент.ТекущиеДанные.КоэффициентКороба);
		СтруктураПараметров.Вставить("ШтрихкодБутылки",ТекущийЭлемент.ТекущиеДанные.ШтрихкодБутылки);
		СтруктураПараметров.Вставить("ИдЗадачи",ИдЗадачи);
		СтруктураПараметров.Вставить("ИдентификаторУпаковки",ИдентификаторУпаковки);
		СтруктураПараметров.Вставить("КоличествоПлан",ТекущийЭлемент.ТекущиеДанные.Количество);
		СтруктураПараметров.Вставить("КоличествоФакт",ТекущийЭлемент.ТекущиеДанные.КоличествоФакт);
		ОткрытьФорму("Документ.итПроверка.Форма.ФормаИзмененияСтроки",СтруктураПараметров,ЭтаФорма);
		ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы="Документ.итПроверка.Форма.ФормаИзмененияСтроки" Тогда 
		Если не ВыбранноеЗначение.ПомарочныйУчет Тогда 
		УстановитьКоличестфоФактВНеПМУСтроке(ВыбранноеЗначение.ИдСтроки,ВыбранноеЗначение.КоличествоФакт);
		КонецЕсли;
		АнализДанных();
		КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКоманд
&НаКлиенте
Процедура Назад(Команда)
		ЭтаФорма.Закрыть();
КонецПроцедуры
&НаСервере
Процедура КомментарийПриИзмененииНаСервере()
	НаборЗаписей=РегистрыСведений.ИтЗадачиНаТСД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдЗадачи.Установить(ИдЗадачи);
	НаборЗаписей.Прочитать();
	Для Каждого стр из НаборЗаписей цикл
		ДанныеДокументаТСД=стр.ДанныеДокументаТСД.Получить();
		Если ТипЗнч(ДанныеДокументаТСД)=Тип("Структура") Тогда 
			ДанныеДокументаТСД.Вставить("Комментарий",Комментарий);
		иначе
			ДанныеДокументаТСД=новый Структура("Комментарий",Комментарий);
		КонецЕсли;
		стр.ДанныеДокументаТСД=новый ХранилищеЗначения(ДанныеДокументаТСД);
	КонецЦикла;
	НаборЗаписей.Записать();
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
		КомментарийПриИзмененииНаСервере();
КонецПроцедуры
&НаКлиенте
Процедура Выполнено(Команда)
		ЗавершитьЗадачуПроверки();
КонецПроцедуры

&НаКлиенте
Процедура ЗадачаНеМожетБытьВыполнена(Команда)
	Если ПричинаОтмены.Пустая() Тогда 
		Сообщить("Заполните пожалуйста причину отмены");
		Возврат
	КонецЕсли;	
	Оповещение=новый ОписаниеОповещения("ЗадачаНеМожетБытьВыполненаОповещение",ЭтаФорма);
	ПоказатьВопрос(Оповещение,"Вы точно хотите отменить задачу?",РежимДиалогаВопрос.ДаНет);
		//ЗавершитьЗадачуПроверки()
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ЗадачаНеМожетБытьВыполненаОповещение(Результат,Параметры) Экспорт 
	Если Результат=КодВозвратаДиалога.Нет Тогда 
		Возврат
	КонецЕсли;	
	ОчиститьДанныеОтмененнойЗадачи();
	Если ЗавершитьЗадачуОтменойПроверкиНаСервере() Тогда 
		ОповеститьОВыборе(Истина);
	КонецЕсли;
КонецПроцедуры
&НаСервере
Процедура ОчиститьДанныеОтмененнойЗадачи()
НаборЗаписей=РегистрыСведений.итДанныеПомарочногоУчета.СоздатьНаборЗаписей();
НаборЗаписей.Отбор.Ключ.Установить(ИдЗадачи);
НаборЗаписей.Прочитать();
Для Каждого стр из НаборЗаписей Цикл 
	стр.ПризнакОбработки=Ложь;
КонецЦикла;
НаборЗаписей.Записать();

Для Каждого стр из ДанныеЗадачи Цикл 
	ЗаписатьКоличествоФактПоИдСтроки(стр.ИдСтроки,0);
	стр.КоличествоФакт=0;
КонецЦикла;
	
КонецПроцедуры

Функция ЗавершитьЗадачуОтменойПроверкиНаСервере()
СтруктураДанных =новый Структура;
СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
СтруктураДанных.Вставить("КлючИнициализацииДанных",ИдЗадачи);
СтруктураДанных.Вставить("ТипЗадачи",Перечисления.итWMSТипыЗадачТСД.Проверка);
СтруктураДанных.Вставить("ТипИнициализации","Задача");
СтруктураДанных.Вставить("СостояниеИнициализации",Перечисления.итWMSСостоянияЗадачТСД.Отменена);
СтруктураДанных.Вставить("ИдентификаторУпаковки",ИдентификаторУпаковки);
СтруктураДанных.Вставить("Ячейка",Ячейка);
СтруктураДанных.Вставить("Инициализация",Ложь);
СтруктураДанных.Вставить("ФиксацияЗадачи",Ложь);
//СтруктураДанных.Вставить("ТипОбработкиДанных","ВнесениеИзмененийВДокумент");
СтруктураДанных.Вставить("ТипОбработкиДанных","ЗаписатьДанныеТСД");
СтруктураДанных.Вставить("ДанныеЗадачи",ДанныеЗадачи.Выгрузить());
СтруктураДанных.Вставить("КонтрольБутылки",КонтрольБутылки);
СтруктураДанных.Вставить("КонтрольКороба",КонтрольКороба);
СтруктураДанных.Вставить("Комментарий",Комментарий);
СтруктураДанных.Вставить("ПричинаОтмены",ПричинаОтмены);
СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"CheckingShipment");
СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураДанных,"Инициализация");
МодульРаспределенияДанных.ОбработчикВходящихДанных(СтруктураДанных);
Возврат  СтруктураДанных.Инициализация;

	КонецФункции


&НаСервере
Процедура УстановитьТекстХелпера()
	Если ПланФактРавны Тогда 
		Если НаличиеПомарочногоУчетаВПаллете  Тогда 
			Если КонтрольБутылки="" и КонтрольКороба="" Тогда 
				Элементы.ИнформативнаяНадпись.Заголовок="Сканируйте контрольную марку и GTIN";
			ИначеЕсли КонтрольБутылки="" и КонтрольКороба<>"" Тогда 
				Элементы.ИнформативнаяНадпись.Заголовок="Сканируйте контрольную марку";
			ИначеЕсли  КонтрольБутылки<>"" и КонтрольКороба="" Тогда 
				Элементы.ИнформативнаяНадпись.Заголовок="Сканируйте контрольный GTIN";
			КонецЕсли;		
			
		иначе
			Если КонтрольБутылки="" и КонтрольКороба="" Тогда 
				Элементы.ИнформативнаяНадпись.Заголовок="Сканируйте ITF14 групповой тары или EAN13 бутылки";
			ИначеЕсли КонтрольБутылки="" и КонтрольКороба<>"" Тогда 
				Элементы.ИнформативнаяНадпись.Заголовок="Сканируйте EAN13 бутылки";
			ИначеЕсли  КонтрольБутылки<>"" и КонтрольКороба="" Тогда 
				Элементы.ИнформативнаяНадпись.Заголовок="Сканируйте ITF14 групповой тары";
			КонецЕсли;				
		КонецЕсли;
		
		
		
		
	иначе
		Элементы.ИнформативнаяНадпись.Заголовок="Подтвердите количество товара";
	КонецЕсли;

КонецПроцедуры
	
&НаСервере
Процедура УстановитьКоличестфоФактВНеПМУСтроке(ИдСтроки,КоличествоФакт)
	МассивСтрок=ДанныеЗадачи.НайтиСтроки(новый Структура("ИдСтроки",ИдСтроки));
	ЗаписатьКоличествоФактПоИдСтроки(ИдСтроки,КоличествоФакт);
	Для Каждого стр из МассивСтрок цикл
		стр.КоличествоФакт=КоличествоФакт;
		стр.ПризнакОбработкиСтроки=Истина;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиЗадачи(Отказ)
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИтЗадачиНаТСД.ДокументОснование КАК ДокументОснование,
		|	ИтЗадачиНаТСД.ИдЗадачи КАК ИдЗадачи,
		|	ИтЗадачиНаТСД.ИдентификаторУпаковки КАК ИдентификаторУпаковки,
		|	ИтЗадачиНаТСД.Состояние КАК Состояние,
		|	ИтЗадачиНаТСД.ЯчейкаОтправитель КАК ЯчейкаОтправитель
		|ПОМЕСТИТЬ ВтДанныеИдЗадачи
		|ИЗ
		|	РегистрСведений.ИтЗадачиНаТСД КАК ИтЗадачиНаТСД
		|ГДЕ
		|	ИтЗадачиНаТСД.ИдЗадачи = &ИдЗадачи
		|
		|СГРУППИРОВАТЬ ПО
		|	ИтЗадачиНаТСД.ДокументОснование,
		|	ИтЗадачиНаТСД.ИдЗадачи,
		|	ИтЗадачиНаТСД.ИдентификаторУпаковки,
		|	ИтЗадачиНаТСД.Состояние,
		|	ИтЗадачиНаТСД.ЯчейкаОтправитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИтСтрокиЗадачНаТСД.ИдЗадачи КАК ИдЗадачи,
		|	ИтСтрокиЗадачНаТСД.ИдСтроки КАК ИдСтроки,
		|	ИтСтрокиЗадачНаТСД.Номенклатура КАК Номенклатура,
		|	ИтСтрокиЗадачНаТСД.НоменклатураПредставление КАК НоменклатураПредставление,
		|	ИтСтрокиЗадачНаТСД.ДатаРозлива КАК ДатаРозлива,
		|	ИтСтрокиЗадачНаТСД.СерияНоменклатуры КАК СерияНоменклатуры,
		|	ИтСтрокиЗадачНаТСД.СерияНоменклатурыПредставление КАК СерияНоменклатурыПредставление,
		|	ИтСтрокиЗадачНаТСД.Количество КАК Количество,
		|	ИтСтрокиЗадачНаТСД.ДополнительныеДанные КАК ДополнительныеДанные,
		|	ИтСтрокиЗадачНаТСД.ДанныеДокументаТСД КАК ДанныеДокументаТСД,
		|	ВтДанныеИдЗадачи.ДокументОснование КАК ДокументОснование,
		|	ВтДанныеИдЗадачи.ИдентификаторУпаковки КАК ИдентификаторУпаковки,
		|	ВтДанныеИдЗадачи.Состояние КАК Состояние,
		|	ВтДанныеИдЗадачи.ЯчейкаОтправитель КАК ЯчейкаОтправитель
		|ИЗ
		|	ВтДанныеИдЗадачи КАК ВтДанныеИдЗадачи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИтСтрокиЗадачНаТСД КАК ИтСтрокиЗадачНаТСД
		|		ПО ВтДанныеИдЗадачи.ИдЗадачи = ИтСтрокиЗадачНаТСД.ИдЗадачи
		|ИТОГИ
		|	МАКСИМУМ(ИдентификаторУпаковки),
		|	МАКСИМУМ(Состояние),
		|	МАКСИМУМ(ЯчейкаОтправитель)
		|ПО
		|	ДокументОснование";
	
	Запрос.УстановитьПараметр("ИдЗадачи", ИдЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДокументОснование = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаДокументОснование.Следующий() Цикл
		Объект=ВыборкаДокументОснование.ДокументОснование;	
		ВыборкаДетальныеЗаписи = ВыборкаДокументОснование.Выбрать();
	    ИдентификаторУпаковки=ВыборкаДокументОснование.ИдентификаторУпаковки;
		Ячейка=ВыборкаДокументОснование.ЯчейкаОтправитель;
		ДанныеЗадачи.Очистить();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НоваяСтрока=ДанныеЗадачи.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,ВыборкаДетальныеЗаписи);
		ДополнительныеДанные=ВыборкаДетальныеЗаписи.ДополнительныеДанные.Получить();
		Если ТипЗнч(ДополнительныеДанные)=Тип("Структура") Тогда 
			Если ДополнительныеДанные.Свойство("ПризнакПомарочногоУчета") Тогда 
				НоваяСтрока.ПомарочныйУчет= ДополнительныеДанные.ПризнакПомарочногоУчета;	
			КонецЕсли;
			Если не ДополнительныеДанные.Свойство("ШтрихкодБутылки") Тогда 
				Отказ=Истина;
				Сообщить("Для Номенклатуры " + ВыборкаДетальныеЗаписи.НоменклатураПредставление + " не найдено свойство <<ШтрихкодБутылки>>");
				Продолжить;
			КонецЕсли;
			Если ТипЗнч(ДополнительныеДанные.ШтрихкодБутылки)<> Тип("Строка") Тогда 
				Отказ=Истина;
				Сообщить("Для Номенклатуры " + ВыборкаДетальныеЗаписи.НоменклатураПредставление + " не верный формат  <<ШтрихкодБутылки>>");
				Продолжить;
			КонецЕсли;	
			Если ДополнительныеДанные.ШтрихкодБутылки="" Тогда 
				Отказ=Истина;
				Сообщить("Для Номенклатуры " + ВыборкаДетальныеЗаписи.НоменклатураПредставление + " не задан штрих-код базовой еденицы");
				Продолжить;
			КонецЕсли;
			НоваяСтрока.ШтрихкодБутылки=ДополнительныеДанные.ШтрихкодБутылки;
			Если не ДополнительныеДанные.Свойство("ШтрихкодКороба") Тогда 
                Отказ=Истина;
				Сообщить("Для Номенклатуры " + ВыборкаДетальныеЗаписи.НоменклатураПредставление + " не найдено свойство   <<ШтрихкодКороба>>");
				Продолжить;
			КонецЕсли;	
			Если  ТипЗнч(ДополнительныеДанные.ШтрихкодКороба)<> Тип("Строка") или ДополнительныеДанные.ШтрихкодКороба="" Тогда 
				Отказ=Истина;
				Сообщить("Для Номенклатуры " + ВыборкаДетальныеЗаписи.НоменклатураПредставление + " не верно задан   <<ШтрихкодКороба>>");
				Продолжить;
			КонецЕсли;	
			НоваяСтрока.ШтрихкодКороба=ДополнительныеДанные.ШтрихкодКороба;
			Если не ДополнительныеДанные.Свойство("КоэффициентКороба") Тогда 
                Отказ=Истина;
				Сообщить("Для Номенклатуры " + ВыборкаДетальныеЗаписи.НоменклатураПредставление + " не найдено свойство   <<КоэффициентКороба>>");
				Продолжить;
			КонецЕсли;	
			Если  ТипЗнч(ДополнительныеДанные.КоэффициентКороба)<> Тип("Число") или ДополнительныеДанные.КоэффициентКороба=0   Тогда 
				Отказ=Истина;
				Сообщить("Для Номенклатуры " + ВыборкаДетальныеЗаписи.НоменклатураПредставление + " не верно задан   <<КоэффициентКороба>>");
				Продолжить;
			КонецЕсли;	
			НоваяСтрока.КоэффициентКороба=ДополнительныеДанные.КоэффициентКороба;
            Если не ДополнительныеДанные.Свойство("КоличествоНаПаллете") Тогда 
                Отказ=Истина;
				Сообщить("Для Номенклатуры " + ВыборкаДетальныеЗаписи.НоменклатураПредставление + " не найдено свойство   <<КоличествоНаПаллете>>");
				Продолжить;
			КонецЕсли;	
			Если  ТипЗнч(ДополнительныеДанные.КоличествоНаПаллете)<> Тип("Число") или ДополнительныеДанные.КоличествоНаПаллете=0  Тогда 
				Отказ=Истина;
				Сообщить("Для Номенклатуры " + ВыборкаДетальныеЗаписи.НоменклатураПредставление + " не верно задан   <<КоличествоНаПаллете>>");
				Продолжить;
			КонецЕсли;	
			НоваяСтрока.КоличествоНаПаллете=ДополнительныеДанные.КоличествоНаПаллете;
			ДанныеДокументаТСД=ВыборкаДетальныеЗаписи.ДанныеДокументаТСД.Получить();
			Если ТипЗнч(ДанныеДокументаТСД)=Тип("Структура") Тогда 
			Если  ДополнительныеДанные.Свойство("КоличествоФакт")  Тогда 
				НоваяСтрока.КоличествоФакт=ДополнительныеДанные.КоличествоФакт;
				НоваяСтрока.ПризнакОбработкиСтроки=Истина;
			КонецЕсли;
			КонецЕсли;

		иначе
			Отказ=Истина;
			Сообщить("Для Номенклатуры " + ВыборкаДетальныеЗаписи.НоменклатураПредставление + " отсутствуют ключевые характеристики");
			КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		Данные=ПолучитьДанныеХранилищаЗадачи();
		Если ТипЗнч(Данные)=Тип("Структура") Тогда 
			Если  Данные.Свойство("Комментарий")  Тогда 
				Комментарий=Данные.Комментарий;
			КонецЕсли;
		КонецЕсли;	
	    АнализДанных();	
КонецПроцедуры
&НаСервере
Процедура АнализДанных()
	ПланФактРавны=Истина;
	Для Каждого стр из ДанныеЗадачи Цикл 
		Если стр.ПомарочныйУчет Тогда 
			НаличиеПомарочногоУчетаВПаллете=Истина;
			КоличествоФакт=КоличествоМарокНоменклатурыЗадачи(стр.Номенклатура,стр.СерияНоменклатуры);
			стр.КоличествоФакт=КоличествоФакт;
		ИначеЕсли не стр.ПомарочныйУчет  и не  стр.ПризнакОбработкиСтроки Тогда 
			ЗаписатьКоличествоФактПоИдСтроки(стр.ИдСтроки,стр.Количество);
			стр.КоличествоФакт=стр.Количество;	
		КонецЕсли;
		Если стр.Количество<>стр.КоличествоФакт Тогда 
			ПланФактРавны=Ложь;
		КонецЕсли;	
	КонецЦикла;
	УстановитьТекстХелпера();	
КонецПроцедуры



&НаСервере
Процедура ЗаписатьКоличествоФактПоИдСтроки(ИдСтроки,КоличествоФакт) Экспорт 
НаборЗаписей=РегистрыСведений.ИтСтрокиЗадачНаТСД.СоздатьНаборЗаписей();
НаборЗаписей.Отбор.идСтроки.Установить(ИдСтроки);
НаборЗаписей.Отбор.ИдЗадачи.Установить(ИдЗадачи);
НаборЗаписей.Прочитать();
Для Каждого стр из НаборЗаписей цикл
	ДанныеХранилища=стр.ДанныеДокументаТСД.Получить();
	Если ТипЗнч(ДанныеХранилища)<>Тип("Структура") Тогда 
		ДанныеХранилища=новый Структура;
	КонецЕсли;
	ДанныеХранилища.Вставить("КоличествоФакт",КоличествоФакт);
	стр.ДанныеДокументаТСД=новый ХранилищеЗначения(ДанныеХранилища);
КонецЦикла;
НаборЗаписей.Записать();
КонецПроцедуры


&НаКлиенте	
Процедура ОбработчкаПолученияДанныхШтрихКода(ШтрихКод)
	Если ПланФактРавны и НаличиеПомарочногоУчетаВПаллете Тогда
		Если КонтрольБутылки="" Тогда
			Если ПодтверждениеСканированияМарки(ШтрихКод) Тогда 
				Перейти ~ВыходИзУсловия;
			КонецЕсли;	
		КонецЕсли;
		Если КонтрольКороба ="" Тогда 
			Если ПодтверждениеСканированияGTIN(ШтрихКод) Тогда 
				Перейти ~ВыходИзУсловия;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли  ПланФактРавны и не НаличиеПомарочногоУчетаВПаллете Тогда 
		Если КонтрольБутылки="" Тогда
			Если ПодтверждениеСканированияEAN13(ШтрихКод) Тогда 
				Перейти ~ВыходИзУсловия;
			КонецЕсли;	
		КонецЕсли;
		Если КонтрольКороба ="" Тогда 
			Если ПодтверждениеСканированияITF14(ШтрихКод) Тогда 
				Перейти ~ВыходИзУсловия;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	Сообщить("сканированы не верные данные");
	~ВыходИзУсловия:
	УстановитьТекстХелпера();
	Если не НаличиеПомарочногоУчетаВПаллете Тогда
		Если КонтрольБутылки<>"" Тогда 
			ЗавершитьЗадачуПроверки();
		КонецЕсли;
	иначе
		Если КонтрольБутылки<>"" и КонтрольКороба<>"" Тогда 
			ЗавершитьЗадачуПроверки();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
&НаСервере
Функция ПодтверждениеСканированияEAN13(ШтрихКод)
	МассивСтрок=ДанныеЗадачи.НайтиСтроки(новый Структура("ШтрихкодБутылки",ШтрихКод));
	Если МассивСтрок.Количество()>0 Тогда 
		КонтрольБутылки=ШтрихКод;
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
	
КонецФункции
&НаСервере
Функция ПодтверждениеСканированияITF14(ШтрихКод)
		МассивСтрок=ДанныеЗадачи.НайтиСтроки(новый Структура("ШтрихкодКороба",ШтрихКод));
	Если МассивСтрок.Количество()>0 Тогда 
		КонтрольКороба=ШтрихКод;
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции
&НаСервере
Функция ПодтверждениеСканированияМарки(ШтрихКод)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	итДанныеПомарочногоУчета.Марка КАК Марка
		|ИЗ
		|	РегистрСведений.итДанныеПомарочногоУчета КАК итДанныеПомарочногоУчета
		|ГДЕ
		|	итДанныеПомарочногоУчета.Ключ = &Ключ
		|	И итДанныеПомарочногоУчета.Марка = &Марка";
	
	Запрос.УстановитьПараметр("Ключ", ИдЗадачи);
	Запрос.УстановитьПараметр("Марка", ШтрихКод);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда 
	КонтрольБутылки=ВыборкаДетальныеЗаписи.Марка;
	Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
	
	
	КонецФункции

&НаСервере
Функция ПодтверждениеСканированияGTIN (ШтрихКод)

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	итДанныеПомарочногоУчета.GTIN КАК GTIN
		|ИЗ
		|	РегистрСведений.итДанныеПомарочногоУчета КАК итДанныеПомарочногоУчета
		|ГДЕ
		|	итДанныеПомарочногоУчета.Ключ = &Ключ
		|	И итДанныеПомарочногоУчета.GTIN = &GTIN";
	
	Запрос.УстановитьПараметр("GTIN", ШтрихКод);
	Запрос.УстановитьПараметр("Ключ", ИдЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда 
		КонтрольКороба=ВыборкаДетальныеЗаписи.GTIN;
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
		
	КонецФункции


&НаСервере	
Функция КоличествоМарокНоменклатурыЗадачи(Номенклатура,СерияНоменклатуры)
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ итДанныеПомарочногоУчета.Марка) КАК Марка,
		|	итДанныеПомарочногоУчета.SSCC КАК SSCC
		|ИЗ
		|	РегистрСведений.итДанныеПомарочногоУчета КАК итДанныеПомарочногоУчета
		|ГДЕ
		|	итДанныеПомарочногоУчета.Ключ = &Ключ
		|	И итДанныеПомарочногоУчета.SSCC = &SSCC
		|	И итДанныеПомарочногоУчета.ПризнакОбработки
		|	И итДанныеПомарочногоУчета.Номенклатура = &Номенклатура
		|	И итДанныеПомарочногоУчета.СерияНоменклатуры = &СерияНоменклатуры
		|
		|СГРУППИРОВАТЬ ПО
		|	итДанныеПомарочногоУчета.SSCC";
	
	Запрос.УстановитьПараметр("SSCC", ИдентификаторУпаковки);
	Запрос.УстановитьПараметр("Ключ", ИдЗадачи);
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	Запрос.УстановитьПараметр("СерияНоменклатуры",СерияНоменклатуры);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда 
		Возврат ВыборкаДетальныеЗаписи.Марка;
	КонецЕсли;
	    Возврат 0;
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
	КонецФункции
&НаКлиенте
Процедура ЗавершитьЗадачуПроверки()
	Если ЗавершитьЗадачуПроверкиНаСервере() Тогда 
		ОповеститьОВыборе(Истина);
	ИначеЕсли ПланФактРавны Тогда 
		Элементы.Выполнено.Видимость=Истина;
		//Элементы.ЗадачаНеМожетБытьВыполнена.Видимость=Ложь;
	Иначе 
		Элементы.Выполнено.Видимость=Ложь;
		//Элементы.ЗадачаНеМожетБытьВыполнена.Видимость=Истина;
	КонецЕсли;	
КонецПроцедуры
&НаСервере
Функция ЗавершитьЗадачуПроверкиНаСервере()
СтруктураДанных =новый Структура;
СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
СтруктураДанных.Вставить("КлючИнициализацииДанных",ИдЗадачи);
СтруктураДанных.Вставить("ТипЗадачи",Перечисления.итWMSТипыЗадачТСД.Проверка);
СтруктураДанных.Вставить("ТипИнициализации","Задача");
СтруктураДанных.Вставить("СостояниеИнициализации",Перечисления.итWMSСостоянияЗадачТСД.Выполнена);
СтруктураДанных.Вставить("ИдентификаторУпаковки",ИдентификаторУпаковки);
СтруктураДанных.Вставить("Ячейка",Ячейка);
СтруктураДанных.Вставить("Инициализация",Ложь);
СтруктураДанных.Вставить("ФиксацияЗадачи",Ложь);
//СтруктураДанных.Вставить("ТипОбработкиДанных","ВнесениеИзмененийВДокумент");
СтруктураДанных.Вставить("ТипОбработкиДанных","ЗаписатьДанныеТСД");
СтруктураДанных.Вставить("ДанныеЗадачи",ДанныеЗадачи.Выгрузить());
СтруктураДанных.Вставить("КонтрольБутылки",КонтрольБутылки);
СтруктураДанных.Вставить("КонтрольКороба",КонтрольКороба);
СтруктураДанных.Вставить("Комментарий",Комментарий);
Если НаличиеПомарочногоУчетаВПаллете Тогда 
	СтруктураДанных.Вставить("ДанныеМарок",ПолучитьДанныеМарокЗадачи());
КонецЕсли;
СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"CheckingShipment");
СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураДанных,"Инициализация");
МодульРаспределенияДанных.ОбработчикВходящихДанных(СтруктураДанных);
Возврат  СтруктураДанных.Инициализация;

	КонецФункции
&НаСервере	
Функция ПолучитьДанныеМарокЗадачи()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИтСтрокиЗадачНаТСД.ИдЗадачи КАК ИдЗадачи,
		|	ИтСтрокиЗадачНаТСД.Номенклатура КАК Номенклатура,
		|	ИтСтрокиЗадачНаТСД.СерияНоменклатуры КАК СерияНоменклатуры
		|ПОМЕСТИТЬ ДанныеЗадачи
		|ИЗ
		|	РегистрСведений.ИтСтрокиЗадачНаТСД КАК ИтСтрокиЗадачНаТСД
		|ГДЕ
		|	ИтСтрокиЗадачНаТСД.ИдЗадачи = &Ключ
		|
		|СГРУППИРОВАТЬ ПО
		|	ИтСтрокиЗадачНаТСД.ИдЗадачи,
		|	ИтСтрокиЗадачНаТСД.Номенклатура,
		|	ИтСтрокиЗадачНаТСД.СерияНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	итДанныеПомарочногоУчета.Марка КАК Марка
		|ИЗ
		|	ДанныеЗадачи КАК ДанныеЗадачи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.итДанныеПомарочногоУчета КАК итДанныеПомарочногоУчета
		|		ПО ДанныеЗадачи.ИдЗадачи = итДанныеПомарочногоУчета.Ключ
		|			И ДанныеЗадачи.Номенклатура = итДанныеПомарочногоУчета.Номенклатура
		|			И ДанныеЗадачи.СерияНоменклатуры = итДанныеПомарочногоУчета.СерияНоменклатуры
		|			И (итДанныеПомарочногоУчета.ПризнакОбработки)";
	
	Запрос.УстановитьПараметр("Ключ", ИдЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса;	
	КонецФункции
&НаСервере
Функция ПолучитьДанныеХранилищаЗадачи()
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИтЗадачиНаТСД.ДанныеДокументаТСД КАК ДанныеДокументаТСД
		|ИЗ
		|	РегистрСведений.ИтЗадачиНаТСД КАК ИтЗадачиНаТСД
		|ГДЕ
		|	ИтЗадачиНаТСД.ИдЗадачи = &ИдЗадачи
		|	И ИтЗадачиНаТСД.ДокументОснование = &ДокументОснование";
	
	Запрос.УстановитьПараметр("ДокументОснование", Объект.Ссылка);
	Запрос.УстановитьПараметр("ИдЗадачи", ИдЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат ВыборкаДетальныеЗаписи.ДанныеДокументаТСД.Получить();	
	КонецЦикла;
	Возврат Неопределено; 	
	КонецФункции
&НаСервере
Процедура СписокВыбораПричнОтмены()
	МассивСпискаВыбора=ПолучитьСписокВыбораПричнОтмены();
	для Каждого стр из МассивСпискаВыбора цикл
		Элементы.ПричинаОтмены.СписокВыбора.Добавить(стр);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокВыбораПричнОтмены()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	итWMS_ПричиныОтменыЗадач.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.итWMS_ПричиныОтменыЗадач КАК итWMS_ПричиныОтменыЗадач";
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса.ВыгрузитьКолонку("Ссылка");
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции

#КонецОбласти