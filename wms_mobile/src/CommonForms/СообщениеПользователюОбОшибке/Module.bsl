
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
	УстановитьЦветФонаКрасным();
	#Если МобильноеПриложениеКлиент  тогда
	Если Вибрация Тогда 
		СредстваМультимедиа.ВоспроизвестиЗвуковоеОповещение(ЗвуковоеОповещение.Нет,Вибрация);
	КонецЕсли;
	Если ЗвуковоеВоспроизведение Тогда 
		Звук=ПолучитьДанныеЗвука();
		СредстваМультимедиа.ВоспроизвестиАудио(Звук,0,,Истина);	
	КонецЕсли;	
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветФонаКрасным()
	Элементы.Группа1.ЦветФона=WebЦвета.Красный;
	ПодключитьОбработчикОжидания("УстановитьЦветФонаБелым",1,Истина);
КонецПроцедуры
&НаКлиенте
Процедура УстановитьЦветФонаБелым()
	Элементы.Группа1.ЦветФона=WebЦвета.Белый;
	ПодключитьОбработчикОжидания("УстановитьЦветФонаКрасным",1,Истина);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ТекстОшибки") тогда
		ТекстОшибки=Параметры.ТекстОшибки;
	иначе
		Отказ=Истина;
	КонецЕсли;	
	Если Параметры.Свойство("ЗвуковоеВоспроизведение") Тогда 
		ЗвуковоеВоспроизведение=Параметры.ЗвуковоеВоспроизведение;
		АдресМедиаФайла=Параметры.АдресМедиаФайла;
	КонецЕсли;
	Если Параметры.Свойство("Вибрация") Тогда 
		Вибрация=Параметры.Вибрация;
	КонецЕсли;	
КонецПроцедуры
&НаСервере	
Функция ПолучитьДанныеЗвука()
		Звук=ПолучитьОбщийМакет(АдресМедиаФайла);
		Возврат Звук;
КонецФункции

&НаКлиенте
Процедура ОК(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры
