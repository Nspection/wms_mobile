
&НаКлиенте
Процедура ок(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Сообщение") тогда
		Сообщение=Параметры.Сообщение;
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

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если МобильноеПриложениеКлиент  тогда
	Если ЗвуковоеВоспроизведение Тогда 
		Звук=ПолучитьДанныеЗвука();
		СредстваМультимедиа.ВоспроизвестиЗвуковоеОповещение(ЗвуковоеОповещение.Нет,Вибрация);
		СредстваМультимедиа.ВоспроизвестиАудио(Звук,0,,Истина);	
	КонецЕсли;	
	#КонецЕсли
	КонецПроцедуры
	
	
&НаСервере	
Функция ПолучитьДанныеЗвука()
		Звук=ПолучитьОбщийМакет(АдресМедиаФайла);
		Возврат Звук;
КонецФункции
