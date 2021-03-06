&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ФлагВыполненияЗапроса=Ложь;
	ПоказатьСтраницы(Ложь,Ложь,Ложь);
	ОбновитьОтображениеКнопок();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеКнопок()
	ОбновитьОтображениеДанных();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьШтрихкодСКамеры(Команда)
	#Если МобильноеПриложениеКлиент  тогда
		МодульМобильныхДивайсовКлиент.СканированиеКамерой(ЭтаФорма,"ШтрихКод","УстановитьШтрихкодСКамеры");
	#КонецЕсли	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьШтрихкодСКамеры(Команда="") Экспорт
	Если НЕ ШтрихКод = Неопределено Тогда
		Объект.ШтрихКод=ШтрихКод;
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страница;
		Элементы.Группа1.ТекущаяСтраница = Элементы.Группа5;
        ОбработкаОповещения("ОбработчикШтрихКода",Объект.ШтрихКод,"ОбработчикШтрихКода");
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихКод(Код)
	Если НЕ Объект.ФлагВыполненияЗапроса Тогда            
		ТипШК=ПолучитьТипШтрихкодаНаСервере(Код);
		Если ТипШК = 0 Тогда
			Сообщить("Считан не верный код "+Код);
			Возврат;
		КонецЕсли; 
		Объект.ШтрихКод = Код;
		ПолучитьИнформациюПоШтрихКодуНаСервере();
		ПоказатьСтраницы(Объект.ПоказыватьКороба,Объект.ПоказыватьФСМ,Объект.ПоказыватьИнфоДоп);
		ОбновитьОтображениеКнопок();
	КонецЕсли;
КонецПроцедуры
 
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если НЕ Объект.ФлагВыполненияЗапроса Тогда
		Если  ИмяСобытия="ОбработчикШтрихКода" и Источник="ОбработчикШтрихКода" тогда
			ШтрихКодУчета =Параметр;
			ВвестиШтрихКод(ШтрихКодУчета);
		КонецЕсли;
		Если ИмяСобытия="ОбработчикШтрихКода" и Источник="ОшибкаЧтения" тогда
			Сообщить("ошибка чтения штрих-кода");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСтраницы(ПоказыватьКороба,ПоказыватьФСМ,ПоказыватьИнфоДоп)
	Элементы.Группа3.Видимость=ПоказыватьКороба;
	Элементы.Группа4.Видимость=ПоказыватьФСМ;
	Элементы.ИнфоДоп.Видимость=ПоказыватьИнфоДоп;
КонецПроцедуры

&НаСервере                                                        
Функция ПолучитьТипШтрихкодаНаСервере(Код) 
	Объект1 = РеквизитФормыВЗначение("Объект");
	возврат Объект1.ПолучитьТипШтрихкодаНаСервере(Код);
КонецФункции

&НаСервере                                                        
Процедура ПолучитьИнформациюПоШтрихКодуНаСервере() 
	Объект1 = РеквизитФормыВЗначение("Объект");
	Объект1.ПолучитьИнформациюПоШтрихКодуНаСервере();
	ЗначениеВРеквизитФормы(Объект1,"Объект");
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИнформациюПоШтрихКоду(Команда)
	ПолучитьИнформациюПоШтрихКодуНаСервере();
	ПоказатьСтраницы(Объект.ПоказыватьКороба,Объект.ПоказыватьФСМ,Объект.ПоказыватьИнфоДоп);
КонецПроцедуры

&НаКлиенте
Процедура ВызватьОповещениеВрежимеОтладки(Команда)
	нстр ="";
	Подсказка = "Введите текст ШК";
	Оповещение = Новый ОписаниеОповещения("ПослеВводаСтроки",ЭтаФорма, Параметры);
	ПоказатьВводСтроки(Оповещение, "", Подсказка, 0, Истина); 
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаСтроки(Строка, Параметры) Экспорт
    Если НЕ Строка = Неопределено Тогда
        ОбработкаОповещения("ОбработчикШтрихКода",Строка,"ОбработчикШтрихКода");
    КонецЕсли;
КонецПроцедуры

