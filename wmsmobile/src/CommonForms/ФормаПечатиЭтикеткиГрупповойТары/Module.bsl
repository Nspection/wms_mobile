#Область ОбработчикиСобытий
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
	КоличествоКопийЭтикетки=1;
	КоличествоЭтикеток=1;
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

&НаКлиенте
Процедура ШтрихКодЭтикеткиДляВоспроизведенияПриИзменении(Элемент)
	ВидимостьДоступностьЭлементовКлиент();
КонецПроцедуры
&НаКлиенте
Процедура ШтрихКодЭтикеткиДляВоспроизведенияОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Элементы.ДекорацияТекущееДействие.Заголовок="Сканируйте SSCC или GTIN";
	Элементы.ДекорацияТекущееДействие.ЦветТекста=WebЦвета.Зеленый;
	Элементы.КоличествоЭтикеток.Видимость=Ложь;
КонецПроцедуры
&НаКлиенте
Процедура ШтрихКодГрупповойТарыБутылкиОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Элементы.ДекорацияТекущееДействие.Заголовок="Сканируйте EAN13,EAN14,Марку";
	Элементы.ДекорацияТекущееДействие.ЦветТекста=WebЦвета.Зеленый;
КонецПроцедуры
&НаКлиенте
Процедура КоличествоКопийЭтикеткиПриИзменении(Элемент)
	Если КоличествоКопийЭтикетки < 1 Тогда 
		КоличествоКопийЭтикетки=1
	КонецЕсли;	
КонецПроцедуры
&НаКлиенте
Процедура КоличествоЭтикетокПриИзменении(Элемент)
	Если КоличествоЭтикеток < 1 Тогда 
		КоличествоЭтикеток=1
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд
&НаКлиенте
Процедура Назад(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	ПечатьНаСервере();
КонецПроцедуры


Процедура ПечатьНаСервере()
	Если Принтер="" Тогда 
		Сообщить("Не указан принтер");
		Возврат;
	КонецЕсли;	
	СтруктураДанных=СформироватьСтруктуруПараметровДляГрупповойЭтикетки();
	Если Элементы.КоличествоЭтикеток.Видимость Тогда 
		СтруктураДанных.ШкУпаковкиТекст="";
		СтруктураДанных.ШкУпаковки="";
		СтруктураДанных.Вставить("ПечатьНовыхЭтикеток",Истина);		
	иначе
		СтруктураДанных.ШкУпаковкиТекст=ШтрихКодЭтикеткиДляВоспроизведения;
		СтруктураДанных.ШкУпаковки=ШтрихКодЭтикеткиДляВоспроизведения;
		СтруктураДанных.Вставить("ПечатьНовыхЭтикеток",Ложь);
	КонецЕсли;
	СтруктураДанных.Продукция=НоменклатураПредставление;
	СтруктураДанных.ИНН=ИНН;
	СтруктураДанных.КПП=КПП;
	СтруктураДанных.КОДЕГАИСорг=КОДЕГАИСорг;
	СтруктураДанных.ДатаИзготовления = ДатаПроизводства;
	СтруктураДанных.СрокГодности =СрокГодности;
	СтруктураДанных.КОДЕГАИСпрод = КОДЕГАИСпрод;
	СтруктураДанных.ДоляСпирта = Креопость;	
	СтруктураДанных.Объем = Объем;
	СтруктураДанных.Количествовкоробе = КоличествоВУпаковке;
	СтруктураДанных.ИнформацияПоСрокуГодности = ИнформацияПоСрокуГодности;
	СтруктураДанных.УсловияХранения = УсловияХранения;
	СтруктураДанных.ОрганизацияИзготовитель=ПроизводительПредставление;
	СтруктураДанных.ЮрФактАдрес = АдресПроизводителя;
	СтруктураДанных.КодИзготовителя="";
	СтруктураДанных.ШкГрупповойТарыТекст=ШтрихКодГрупповойТары;
	СтруктураДанных.ШкГрупповойТары=ШтрихКодГрупповойТары;
	СтруктураДанных.Вставить("КоличествоКопийЭтикетки",КоличествоКопийЭтикетки);
	СтруктураДанных.Вставить("КоличествоЭтикеток",КоличествоЭтикеток);
    СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
	СтруктураДанных.Вставить("Принтер",Принтер);
	СтруктураДанных.Вставить("GTIN",GTINТригер);
    СтруктураДанных.Вставить("КлючОперации","ПечатьЭтикеткиГрупповойТары");
    СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"ServiceFunction");


	КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ВидимостьДоступностьЭлементовКлиент()
	Если ШтрихКодЭтикеткиДляВоспроизведения <> "" Тогда 
		Элементы.КоличествоЭтикеток.Видимость=Ложь;
		Элементы.GTIN.Видимость=Ложь;
		КоличествоЭтикеток=1;
	иначе
		Элементы.КоличествоЭтикеток.Видимость=Истина;
		Элементы.GTIN.Видимость=Истина;
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура ОбработчкаПолученияДанныхШтрихКода(ШтрихКод)
	Если Элементы.ДекорацияТекущееДействие.Заголовок="Сканируйте SSCC или GTIN" Тогда 
		УстановитьДанныеSSCCGTIN(ШтрихКод);
		ШтрихКодЭтикеткиДляВоспроизведенияПриИзменении("");
		Возврат
	КонецЕсли;
	Если Элементы.ДекорацияТекущееДействие.Заголовок="Сканируйте EAN13,EAN14,Марку"  Тогда
		УстановитьДанныеМаркиБутулкиКороба(ШтрихКод);
		Возврат
	КонецЕсли;
	
	АвтоАнализОтсканированногоШк(ШтрихКод);
	ВидимостьДоступностьЭлементовКлиент();
КонецПроцедуры
&НаСервере
Процедура УстановитьДанныеSSCCGTIN(ШтрихКод)
	SSCC="";
	GTIN="";
	Если ЭтоИдентификаторУпаковки(ШтрихКод,SSCC,GTIN) Тогда 
	ШтрихКодЭтикеткиДляВоспроизведения=ШтрихКод;
	ПолучитьДанныеSSCCGTINССервера(SSCC,GTIN);
	УстановитьТиповуюЗаписьзаголовка();
	КонецЕсли;
	КонецПроцедуры
&НаСервере
Процедура ПолучитьДанныеSSCCGTINССервера(SSCC="",GTIN="")
СтруктураДанных=новый Структура;
СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
Если SSCC<>"" Тогда 
СтруктураДанных.Вставить("SSCC",SSCC);
иначе
СтруктураДанных.Вставить("GTIN",GTIN);
КонецЕсли;
СтруктураДанных.Вставить("КлючОперации","ПолучитьДанныеПаллетыКоробаПМУ");
СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"ServiceFunction");
УстановитьДанныеВШаблон(СтруктураДанных);
КонецПроцедуры
&НаСервере
Процедура УстановитьТиповуюЗаписьзаголовка()
	Элементы.ДекорацияТекущееДействие.Заголовок="Заполните данные этикетки";
	Элементы.ДекорацияТекущееДействие.ЦветТекста=WebЦвета.КожаноКоричневый;
	КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеМаркиБутулкиКороба(ШтрихКод)
	Марка="";
	EAN="";
	Если СтрДлина(ШтрихКод)>30 Тогда 
		Марка=ШтрихКод;
	иначе
		EAN=ШтрихКод;
	КонецЕсли;
	ПолучитьДанныеМаркиEANССервера(Марка,EAN);
	ШтрихКодПоискаДанных=ШтрихКод;
	УстановитьТиповуюЗаписьзаголовка();
КонецПроцедуры
&НаСервере
Процедура ПолучитьДанныеМаркиEANССервера(Марка="",EAN="")
СтруктураДанных=новый Структура;
СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
Если Марка<>"" Тогда 
СтруктураДанных.Вставить("Марка",Марка);
иначе
СтруктураДанных.Вставить("EAN",EAN);
КонецЕсли;
СтруктураДанных.Вставить("КлючОперации","ПолучитьДанныеМаркиEAN");
СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"ServiceFunction");
УстановитьДанныеВШаблон(СтруктураДанных);
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеВШаблон(СтруктураДанных)
	Если СлужебныеФункцииИПроцедурыКлиентСервер.ТиповойОбработчикОшибок(СтруктураДанных) Тогда 
		Возврат
	КонецЕсли;	
	ДанныеЭтикетки=СтруктураДанных.ДанныеЭтикетки;
	Если ДанныеЭтикетки.Свойство("ДатаИзготовления") Тогда 
		ДатаПроизводства=ДанныеЭтикетки.ДатаИзготовления;
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("ДоляСпирта") Тогда 
		Креопость=NotNull(ДанныеЭтикетки.ДоляСпирта,"Число");
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("ИНН") Тогда 
		ИНН=NotNull(ДанныеЭтикетки.ИНН);
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("КПП") Тогда 
		КПП=NotNull(ДанныеЭтикетки.КПП);
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("Количествовкоробе") Тогда 
		КоличествоВУпаковке= ДанныеЭтикетки.Количествовкоробе;
		КонецЕсли;
	//Если ДанныеЭтикетки.Свойство("Организация") Тогда 
	//	Организация=NotNull(ДанныеЭтикетки.Организация);
	//КонецЕсли;
	Если ДанныеЭтикетки.Свойство("ОрганизацияИзготовитель") Тогда 
		ПроизводительПредставление=NotNull(ДанныеЭтикетки.ОрганизацияИзготовитель);
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("Объем") Тогда 
		Объем=NotNull(ДанныеЭтикетки.Объем,"Число");
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("Продукция") Тогда 
		НоменклатураПредставление=NotNull(ДанныеЭтикетки.Продукция);
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("СрокГодности") Тогда 
		СрокГодности=NotNull(ДанныеЭтикетки.СрокГодности,"Дата");
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("УсловияХранения") Тогда 
		УсловияХранения=NotNull(ДанныеЭтикетки.УсловияХранения);
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("ШкГрупповойТары") Тогда
		ШтрихКодГрупповойТары=NotNull(ДанныеЭтикетки.ШкГрупповойТары);
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("ЮрФактАдрес") Тогда
		АдресПроизводителя=NotNull(ДанныеЭтикетки.ЮрФактАдрес);
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("КодИзготовителя") Тогда
		КодПроизводителя= NotNull(ДанныеЭтикетки.КодИзготовителя);
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("КОДЕГАИСорг") Тогда
		КОДЕГАИСорг=NotNull(ДанныеЭтикетки.КОДЕГАИСорг);
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("КОДЕГАИСпрод") Тогда
		КОДЕГАИСпрод= NotNull(ДанныеЭтикетки.КОДЕГАИСпрод);
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("ИнформацияПоСрокуГодности") Тогда
		ИнформацияПоСрокуГодности= NotNull(ДанныеЭтикетки.ИнформацияПоСрокуГодности,"Дата");
	КонецЕсли;
	Если ДанныеЭтикетки.Свойство("ТекущийПринтерПредставление") Тогда
		Принтер= NotNull(ДанныеЭтикетки.ТекущийПринтерПредставление);
	КонецЕсли;
КонецПроцедуры
&НаСервере
Функция NotNull(Данные,Тип="")
	Если Данные=null или Данные=Неопределено Тогда 
		Если  НРег(Тип)=НРег("") или Тип=НРег("Строка") Тогда 
			Возврат "";
		КонецЕсли;
		Если  НРег(Тип)=НРег("Число") Тогда 
			Возврат 0;
		КонецЕсли;
		Если  НРег(Тип)=НРег("Дата") Тогда 
			Возврат '00010101';
		КонецЕсли;
		Если НРег(Тип) = НРег("Булево") Тогда 
			Возврат Ложь;
		КонецЕсли;	
	КонецЕсли;	
	Возврат Данные;
	КонецФункции
&НаСервере
Процедура АвтоАнализОтсканированногоШк(ШтрихКод)
ДлинаШк=СтрДлина(ШтрихКод);
Если ДлинаШк>36 Тогда 
	УстановитьДанныеМаркиБутулкиКороба(ШтрихКод);	
ИначеЕсли ДлинаШк=36 Тогда 
	УстановкаДанныхПоГуид(ШтрихКод);
ИначеЕсли  ЭтоИдентификаторУпаковки(ШтрихКод,"","") Тогда 
	УстановитьДанныеSSCCGTIN(ШтрихКод);
иначе
   УстановитьДанныеМаркиБутулкиКороба(ШтрихКод);	
КонецЕсли;
КонецПроцедуры
&НаСервере
Процедура УстановкаДанныхПоГуид(ШтрихКод)
Гуид=новый УникальныйИдентификатор(ШтрихКод);
СтруктураДанных=новый Структура;
СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
СтруктураДанных.Вставить("Гуид",Гуид);
СтруктураДанных.Вставить("КлючОперации","ПолучитьДанныеОрганизацииПринтераПоГуиду");
СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"ServiceFunction");
УстановитьДанныеВШаблон(СтруктураДанных);
КонецПроцедуры

// Функция - Сформировать структуру параметров для групповой этикетки
// 
// Возвращаемое значение:
// Структура  - Структура  параметров  для печати групповой этикетки 
//
Функция СформироватьСтруктуруПараметровДляГрупповойЭтикетки() Экспорт 
	СтруктураПараметров=новый Структура;
	СтруктураПараметров.Вставить("ШкУпаковкиТекст","");
	СтруктураПараметров.Вставить("ШкУпаковки","");
	СтруктураПараметров.Вставить("Продукция","");
	СтруктураПараметров.Вставить("ИНН","");
	СтруктураПараметров.Вставить("КПП","");
	СтруктураПараметров.Вставить("КОДЕГАИСорг","");
	СтруктураПараметров.Вставить("ДатаИзготовления",'00010101');
    СтруктураПараметров.Вставить("СрокГодности",'00010101');
	СтруктураПараметров.Вставить("КОДЕГАИСпрод","");
	СтруктураПараметров.Вставить("ДоляСпирта",0);
	СтруктураПараметров.Вставить("Объем",0);
	СтруктураПараметров.Вставить("Количествовкоробе",0);
	СтруктураПараметров.Вставить("ИнформацияПоСрокуГодности","Срок годности не ограничен при соблюдении условий хранения");
	СтруктураПараметров.Вставить("УсловияХранения","Хранить в вентилируемых, не имеющих постороннего запаха помещениях,"+
	"исключающих воздействие прямого солнечного света,"+
	" при температуре от 5°С до 20°С и относительной влажности воздуха не более 85%");
	СтруктураПараметров.Вставить("ОрганизацияИзготовитель","");
	СтруктураПараметров.Вставить("ЮрФактАдрес","");
	СтруктураПараметров.Вставить("КодИзготовителя","");
	СтруктураПараметров.Вставить("ШкГрупповойТарыТекст","");
	СтруктураПараметров.Вставить("ШкГрупповойТары","");
	
    Возврат СтруктураПараметров;
КонецФункции


&НаСервере
Функция ЭтоИдентификаторУпаковки(ШтрихКод,SSCC,GTIN)
Отказ=Ложь;
СлужебныеФункцииИПроцедурыКлиентСервер.ПроверитьSSCCНаЛеквидность(ШтрихКод,Отказ,Ложь);
Если не Отказ  Тогда 
	SSCC=ШтрихКод; 
	Возврат Истина;
КонецЕсли;
Отказ=Ложь;
СлужебныеФункцииИПроцедурыКлиентСервер.ПроверитьGTINНаЛеквидность(ШтрихКод,Отказ,Ложь);
Если не Отказ  Тогда 
	GTIN=ШтрихКод;
	Возврат Истина;
КонецЕсли;
Возврат Ложь;
	КонецФункции



#КонецОбласти





