&НаКлиенте
Перем Компонента;
#Область ОбработчикиСобытий
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	 Константы.ДатаВремяВызоваСервера.Установить('00010101');
	 СлужебныеФункцииИПроцедурыКлиентСервер.ОчисткаЛогаЗаСутки();
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
		    
	АдресИнформацииОбновленияБазы=СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы(новый Структура,ЭтаФорма.УникальныйИдентификатор);
	//АдресИнформацииОбновленияБазы=ПоместитьВоВременноеХранилище(новый Структура,ЭтаФорма.УникальныйИдентификатор);
	ПодключитьОбработчикОжидания("ОбработчикОжиданияАвторизации",1,Истина);
	ПодключитьОбработчикОжидания("ОбработчикСверкиСоединенияСервера",15,Истина);

КонецПроцедуры
&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если не ЗавершениеРаботы  тогда
		СлужебныеФункцииИПроцедурыКлиентСервер.ПриЗакрытииФормыВременноеХранилище(ЭтаФорма.УникальныйИдентификатор);
		ЗавершитьРаботуСистемы();	
	КонецЕсли;

КонецПроцедуры
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	#Если МобильноеПриложениеКлиент  тогда
		Уведомление=новый ДоставляемоеУведомление();
		//Уведомление.ЗвуковоеОповещение=ЗвуковоеОповещение.ПоУмолчанию;
		Уведомление.Текст="ЗавршениеРаботыWMS";
		Уведомление.Данные="ЗавршениеРаботыWMS";
		ДоставляемыеУведомления.ДобавитьЛокальноеУведомление(Уведомление);
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКоманд		
&НаКлиенте
Процедура НовыйЗадачиТСД(Команда)
	ОткрытьФорму("Обработка.ДиспетчерЗадач.Форма.ЗадачТСДКРаспределениюПоРазделам",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

&НаКлиенте
Процедура МоиЗадачи(Команда)
	ОткрытьФорму("Обработка.ДиспетчерЗадач.Форма.ЗадачиНаТСДПоРазделам",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры
&НаКлиенте
Процедура СервесноеОбслуживание(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаСервесногоОбслуживания",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныйФункционал(Команда)
	ОткрытьФорму("ОбщаяФорма.МенюДополнительногоФункционала",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	ЗавершитьРаботуСистемы();
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиТСДНовыйИнтерфейс(Команда)
	//ОткрытьФорму("ОбщаяФорма.ФормаСпискаЗадачТСДКРаспределению",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
КонецПроцедуры

#КонецОбласти
#Область ПрочиеСлужебныеФункцииИПроцедуры
&НаКлиенте
Процедура ОбработчикОжиданияАвторизации()Экспорт
	Если ПодтверждениеАвторизации() тогда
		ОчиститьСообщения();
		Сообщение="             Добро пожаловать 
		|   "+ СлужебныеФункцииИПроцедурыКлиентСервер.ПараметрыСеансаОтветСервера("ТекущийПользователь");
		ОткрытьФорму("ОбщаяФорма.СообщениеПользователю",новый Структура("Сообщение,ЗвуковоеВоспроизведение,АдресМедиаФайла",Сообщение,Истина,"ПриветсвиеMp3"));
		/// SDE
		 	Если униРежимПодключенияЧерезUWSНаСервере() Тогда
	    		 Элементы.Группа1.Видимость = Ложь;
			иначе
 	    		 Элементы.Группа3.Видимость = Ложь;
			КонецЕсли; 
		///
		ПодключениеОпросаСервераБазыДанных();
		Пользователь=СлужебныеФункцииИПроцедурыКлиентСервер.ПараметрыСеансаОтветСервера("ТекущийПользователь")+"
		|"+СлужебныеФункцииИПроцедурыКлиентСервер.ПараметрыСеансаОтветСервера("Роль");
		Попытка	
		ПодключитьВнешнююКомпоненту("ОбщийМакет.AddIn", "LibData", ТипВнешнейКомпоненты.Native); 
		Компонента = Новый("AddIn.LibData.AddInNativeBEN");	
		//Компонента.StartGetScan();
		Модель=СлужебныеФункцииИПроцедурыКлиентСервер.ПолучитьМодельТСД();
        Если Найти(Модель,"MC33") Тогда 
			Компонента.StartMyGetScan("com.symbol.datawedge.DWDEMO","com.symbol.datawedge.data_string");
		Иначе 
			Компонента.StartGetScan();
		КонецЕсли;

		Компонента.StartGetKeyEvent();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("драйвер сканирования не смог создать подключения-- сканирование на текущем устройстве работать не будет");
		КонецПопытки;
		ТригерПриемаСканераШтрихКода=Истина;
	иначе
		ПодключитьОбработчикОжидания("ОбработчикОжиданияАвторизации",1,Истина);
	КонецЕсли;
КонецПроцедуры
&НаСервере
Функция ПодтверждениеАвторизации()
	Если ПараметрыСеанса.ТекущийПользователь<>"" тогда
		Возврат Истина
	иначе
		Возврат ложь
	КонецЕсли;	
КонецФункции

&НаСервере
Функция униРежимПодключенияЧерезUWSНаСервере()
	Возврат ПараметрыСеанса.униРежимПодключенияЧерезUWS;
КонецФункции


&НаКлиенте
Процедура ПодключениеОпросаСервераБазыДанных()
	ПодключитьОбработчикОжидания("ОпросСервераБазыДанных",60,Ложь);
	ПодключитьОбработчикОжидания("ОповещениеОбИзменениях",15,Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСверкиСоединенияСервера() Экспорт 
	СверкаДанныхСоединенияСервера();
	ПодключитьОбработчикОжидания("ОбработчикСверкиСоединенияСервера",15,Истина);
КонецПроцедуры

&НаСервере
Процедура СверкаДанныхСоединенияСервера()
	ДатаКонстанты=Константы.ДатаВремяВызоваСервера.Получить();
	Если ДатаКонстанты='00010101' Тогда 
		Возврат
	КонецЕсли;
	Если ДатаКонстанты>ТекущаяДатаСеанса() Тогда 
		Константы.ДатаВремяВызоваСервера.Установить(ТекущаяДатаСеанса());
		Возврат;
	КонецЕсли;
	РазницаВСекунлах=ТекущаяДатаСеанса()-ДатаКонстанты;
	Если РазницаВСекунлах>=180  Тогда 
		  Константы.ДатаВремяВызоваСервера.Установить('00010101');
	КонецЕсли;	  
	КонецПроцедуры
#КонецОбласти
#Область ИнформацияОбИзменениях	
&НаКлиенте
Процедура ОповещениеОбИзменениях() Экспорт 
	Попытка
		МассивСозданныхОбъектовДанных=ПроверитьИнформациюОбИзменениях();
		Если  МассивСозданныхОбъектовДанных.Количество()<>0 тогда
			СлужебныеФункцииИПроцедурыКлиентСервер.ПоместитьВоВременноеХранилищеФормы(новый Структура,АдресИнформацииОбновленияБазы);
			//ПоместитьВоВременноеХранилище(новый Структура,АдресИнформацииОбновленияБазы);
			Если ТригерПриемаСканераШтрихКода тогда
				ОткрытьФорму("Обработка.ДиспетчерЗадач.Форма.ПолученныеЗадачи",новый Структура("МассивСозданныхОбъектовДанных",МассивСозданныхОбъектовДанных),ЭтаФорма);
				ТригерПриемаСканераШтрихКода=Ложь;
			иначе 
				Оповестить("ПолученныеЗадачи",новый Структура("МассивСозданныхОбъектовДанных",МассивСозданныхОбъектовДанных),ЭтаФорма.ИмяФормы);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	ПодключитьОбработчикОжидания("ОповещениеОбИзменениях",15,Истина);	
КонецПроцедуры
&НаСервере
Функция ПроверитьИнформациюОбИзменениях()	
	Данные=СлужебныеФункцииИПроцедурыКлиентСервер.ПолучитьИзВременногоХранилищаФормы(АдресИнформацииОбновленияБазы);
	//Данные=ПолучитьИзВременногоХранилища(АдресИнформацииОбновленияБазы);
	Если  ТипЗнч(Данные)=тип("Структура") тогда
		Если Данные.Свойство("МассивСозданныхОбъектовДанных") тогда
			Возврат Данные.МассивСозданныхОбъектовДанных;
		КонецЕсли;
	КонецЕсли;
	Возврат новый Массив;
КонецФункции
#КонецОбласти
#Область ПолучениеДанныхССервера
&НаКлиенте
Процедура ОпросСервераБазыДанных() Экспорт 
	//ОпросСервераБазыДанныхНаСервере()
	ОпросСервераБазыДанныхНаСервереАссинхронно();
КонецПроцедуры
&НаСервере
Процедура ОпросСервераБазыДанныхНаСервере()
	ОбработчикиЗапросаСервера.ОпросСервераБазыДанныхНаСервере();
КонецПроцедуры
&НаСервере
процедура ОпросСервераБазыДанныхНаСервереАссинхронно()
	МассивЗаданий=ФоновыеЗадания.ПолучитьФоновыеЗадания(новый Структура("Ключ",КлючПоследнегоАссинхронногоЗадания));
	Для Каждого Задания из МассивЗаданий цикл
		Если Задания.Состояние=СостояниеФоновогоЗадания.Активно тогда
			Возврат
		КонецЕсли;	
	КонецЦикла;
	ПараметрыМетода = новый Массив;
	СтруктураДанных = новый Структура();
	СлужебныеФункцииИПроцедурыКлиентСервер.СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
	СтруктураДанных.Вставить("АдресИнформацииОбновленияБазы",АдресИнформацииОбновленияБазы);
	ПараметрыМетода.Добавить(СтруктураДанных);
	КлючПоследнегоАссинхронногоЗадания=новый УникальныйИдентификатор;
	ФоновыеЗадания.Выполнить("ОбработчикиЗапросаСервера.ОпросСервераБазыДанныхНаСервере",ПараметрыМетода,КлючПоследнегоАссинхронногоЗадания,"опрос сервера");
КонецПроцедуры

&НаКлиенте
Процедура униКонтрольныеОперации(Команда)
	ОткрытьФорму("Документ.униНаборкаАгрегация.ФормаСписка",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура униОбратнаяДезагрегация(Команда)
		ОткрытьФорму("Документ.униИзбыточнаяДезАгрегация.ФормаСписка",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;

КонецПроцедуры

&НаКлиенте
Процедура униВызватьОбработкуСтатусаОбъекта(Команда)
			ОткрытьФорму("Обработка.униПроверкаПоШтрихкоду.Форма.Форма",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;

КонецПроцедуры

&НаКлиенте
Процедура униПоместитьВЯчейку(Команда)
		ОткрытьФорму("Документ.униПоместитьВЯчейку.ФормаСписка",,ЭтаФорма);
	ТригерПриемаСканераШтрихКода=Ложь;

КонецПроцедуры








#КонецОбласти

