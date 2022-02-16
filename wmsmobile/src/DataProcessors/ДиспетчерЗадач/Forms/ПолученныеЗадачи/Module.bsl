
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	если Параметры.Свойство("МассивСозданныхОбъектовДанных") тогда
		для Каждого стр из Параметры.МассивСозданныхОбъектовДанных цикл
			СписокОбъектовДанных.Добавить(стр);
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВМоиЗадачи(Команда)
	ЭтаФорма.Закрыть();
	ОткрытьФорму("Обработка.ДиспетчерЗадач.Форма.МоиЗадачиОбщийСписок",,ЭтаФорма.ВладелецФормы);
	ТригерПриемаСканераШтрихКода=Ложь;
	/// страховка на отключения тригера штрих кохда
	ВладелецФормы.ТригерПриемаСканераШтрихКода=Ложь;
	НеВозвращатьКонтрольНадТригером=Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриОткрытии(ЭтаФорма);
//ПодключитьОбработчикОжидания("ОтключитьТригерПриемаШтрихКодаСЗадержкой",1,Истина);
КонецПроцедуры
&НаКлиенте
Процедура ОтключитьТригерПриемаШтрихКодаСЗадержкой()Экспорт 
	ВладелецФормы.ТригерПриемаСканераШтрихКода=Ложь;
	КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если  не НеВозвращатьКонтрольНадТригером тогда
	ОбщийМодульКлиентскойЧасти.ПереопределенияТригераПолучениеШтрихКодаПриЗакрытии(ЭтаФорма);
	КонецЕсли;
КонецПроцедуры
