// Функция - Сформировать строку подключения
// 
// Возвращаемое значение:
// Строка - данные подключения к серверной базе 
//
Функция СформироватьСтрокуПодключения() Экспорт 
	Параметры=СформироватьПараметрыПодключения();
	IPАдресСервера=Параметры.IPАдресСервера;
	ИмяПубликацииБазы=Параметры.ИмяПубликацииБазы;
	URLПространствоВебСервиса=Параметры.URLПространствоВебСервиса;
	
	СтрокаWSОпределения = "http://"+СокрЛП(IPАдресСервера)+"/"+СокрЛП(ИмяПубликацииБазы)+"/ws/"+СокрЛП(URLПространствоВебСервиса)+".1cws?wsdl";
	Возврат СтрокаWSОпределения;
КонецФункции
// Функция - Сформировать параметры подключения
// 
// Возвращаемое значение:
// Структура - содержит данные IPАдресСервера,ИмяПубликацииБазы,URLПространствоВебСервиса типа строка.
//
Функция СформироватьПараметрыПодключения()Экспорт 
	IPАдресСервера=СокрЛП(Константы.IPАдресСервера.Получить());
	ИмяПубликацииБазы=СокрЛП(Константы.ИмяПубликацииБазы.Получить());
	URLПространствоВебСервиса=СокрЛП(Константы.URLПространствоВебСервиса.Получить());
	Структура=новый Структура("IPАдресСервера,ИмяПубликацииБазы,URLПространствоВебСервиса",IPАдресСервера,ИмяПубликацииБазы,URLПространствоВебСервиса);
	Возврат Структура
КонецФункции
// Функция - Сформировать параметры прокси сервера
// 
// Возвращаемое значение:
// Структура - структура строковых значений для подключения  URLПространствоИменСервиса,ИмяСервиса,ИмяТочкиПодключения
//
Функция СформироватьПараметрыПроксиСервера() Экспорт 
	URLПространствоВебСервиса=Константы.URLПространствоВебСервиса.Получить();
	Структура=новый Структура;
	Структура.Вставить("URLПространствоИменСервиса",СокрЛП(URLПространствоВебСервиса));
	Структура.Вставить("ИмяСервиса",СокрЛП(URLПространствоВебСервиса));
	Структура.Вставить("ИмяТочкиПодключения",СокрЛП(URLПространствоВебСервиса)+"Soap");
	
	Возврат Структура
КонецФункции
// Функция - Представление типа задачи ТСД
//
// Параметры:
//  ТипЗадачиПеречисление	 - Перечисления.итWMSТипыЗадачТСД -  
// 
// Возвращаемое значение:
//  Строка - Строкове представление типа задачи  
//
Функция ПредставлениеТипаЗадачиТСД(ТипЗадачиПеречисление) Экспорт 
	Возврат СтрЗаменить(ТРег(Строка(ТипЗадачиПеречисление))," ","");
КонецФункции
// Процедура - Проверка подключения
//
// Параметры:
//  Отказ	 - Булево
//
Процедура ПроверкаПодключения(Отказ) Экспорт
	
	IPАдресСервера=Константы.IPАдресСервера.Получить();
	ИмяПубликацииБазы=Константы.ИмяПубликацииБазы.Получить();
	URLПространствоВебСервиса=Константы.URLПространствоВебСервиса.Получить();
	МассивНеЗаполненныхЗначений=новый Массив;
	Если не ЗначениеЗаполнено(IPАдресСервера) тогда
		МассивНеЗаполненныхЗначений.Добавить("IPАдресСервера");
	КонецЕсли;
	Если не ЗначениеЗаполнено(ИмяПубликацииБазы)  тогда
		МассивНеЗаполненныхЗначений.Добавить("ИмяПубликацииБазы");
	КонецЕсли;	
	
	Если не ЗначениеЗаполнено(URLПространствоВебСервиса)  тогда
		МассивНеЗаполненныхЗначений.Добавить("URLПространствоВебСервиса");
	КонецЕсли;	
	Если  МассивНеЗаполненныхЗначений.Количество()>0 тогда
		Сообщение = "Не заполненны обязательные поля подключения:";
		для Каждого  стр из МассивНеЗаполненныхЗначений цикл
			Сообщение = Сообщение+стр+";";
		КонецЦикла;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение);
		Отказ=Истина;
		Возврат
	КонецЕсли;
	Попытка
		СтруктураОтвета=ОбработчикиЗапросаСервера.ЗапроситьДанные(новый Структура,"response");
	Исключение
		СтруктураОтвета=новый Структура("Статус,Ошибка",404,ОписаниеОшибки());
	КонецПопытки;
	Если СтруктураОтвета.Статус=404 тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Попытка не удалась по причине: "+СтруктураОтвета.Ошибка);
		Отказ=Истина;
	КонецЕсли;	
КонецПроцедуры

// Процедура - Сформировать структуру данных о пользователе
// если тип СтруктураДанных=неопределенно, то создает новыую структуру. 
// Параметры:
// СтруктураДанных	 - Структура,Неопределено - Структура в которую будут добавленны данные о пользователе и тсд 
//
Процедура СформироватьСтруктуруДанныхОПользователе(СтруктураДанных=Неопределено)Экспорт
	Если СтруктураДанных=Неопределено тогда
		СтруктураДанных=новый Структура;
	КонецЕсли;
	СтруктураДанных.Вставить("ТекущийПользователь",ПараметрыСеанса.ТекущийПользователь);
	СтруктураДанных.Вставить("ТСДИД",ПараметрыСеанса.ТСДИД);
	СтруктураДанных.Вставить("Роль",ПараметрыСеанса.Роль);
	СтруктураДанных.Вставить("Территория",ПараметрыСеанса.Территория);
	СтруктураДанных.Вставить("Принтер",ПараметрыСеанса.Принтер);
КонецПроцедуры

// Функция - Параметры сеанса ответ сервера
//
// Параметры:
//  ПараметрСеанса	 - Строка - имя параметра сеанса 
// 
// Возвращаемое значение:
// Произвольный - значение параметры сеанса 
//
Функция ПараметрыСеансаОтветСервера(ПараметрСеанса)Экспорт
	Возврат ПараметрыСеанса[ПараметрСеанса];
КонецФункции

// Функция - Типовой обработчик ошибок
//
// Параметры:
//  СтруктураДанных	 - Структура - еслти тип значения будет не структура, то он будет преобразован к структуре со свойствами "Статус" и  "ОписаниеОшибки"
//  Свойство		 - Строка	 - Имя свойства,наличие которого необходимо проверить в "СтруктураДанных".
// 
// Возвращаемое значение:
//  Булево - Истина,если были найдены ошибки,иначе ложь. (СтруктураДанных в поле ОписаниеОшибки - содержит описание ошибки )
//
Функция ТиповойОбработчикОшибок(СтруктураДанных,Свойство="") Экспорт 
	Ошибка=Ложь;
	
	Если ТипЗнч(СтруктураДанных)<> тип("Структура") тогда
		СтруктураДанных=новый Структура;
		СтруктураДанных.Вставить("Статус",404);
		СтруктураДанных.Вставить("ОписаниеОшибки","Не верный формат данных----нужен тип <<Структура>>");
	КонецЕсли;
	Если СтруктураДанных.Свойство("Статус") тогда
		Если СтруктураДанных.Статус=404 тогда
			Ошибка=Истина;
			Если СтруктураДанных.Свойство("ОписаниеОшибки") тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтруктураДанных.ОписаниеОшибки);
			иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неизвестная ошибка");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	////////////////////////
	Если Свойство="" тогда
		Возврат Ошибка;
	КонецЕсли;
	///////////////////
	Если не СтруктураДанных.Свойство(Свойство) тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("отсутсвует ключевое свойство <<"+Свойство+">> ");
		Ошибка=Истина;
		Возврат Ошибка;
	КонецЕсли;	
	
	Возврат Ошибка;
КонецФункции

// Процедура - Перед завершением работы системы
// если терминал находиться под управлением пользователя и он хочет выйти из программы отпрвляет данные на сервер, о том
// что пользователь заканчивает работы с ПП
Процедура ПередЗавершениемРаботыСистемы() Экспорт 
	Если ПараметрыСеансаОтветСервера("ТекущийПользователь")<>"" тогда
		ДанныеАвторизации=Неопределено;
		СформироватьСтруктуруДанныхОПользователе(ДанныеАвторизации);
		ДанныеАвторизации.Вставить("Принято",Ложь);
		ДанныеАвторизации=ОбработчикиЗапросаСервера.ЗапроситьДанные(ДанныеАвторизации,"unRegistration");
	КонецЕсли;
КонецПроцедуры

// Функция - Получить макет драйвера
//
// Параметры:
//  ИмяМакета	 - Строка - имя макета содержащего двоичные данные драйвера 
// 
// Возвращаемое значение:
//  Строка - Адрес во временном хранилище, куда были помещены двоичные данные макета 
//
Функция ПолучитьМакетДрайвера(ИмяМакета) Экспорт
	
	Возврат ПоместитьВоВременноеХранилище(ПолучитьОбщийМакет(ИмяМакета));
	
КонецФункции

// Функция - Получить двоичные данные драйвера
//
// Параметры:
//  ИмяМакета	 - Строка - имя макета содержащего двоичные данные драйвера 
// 
// Возвращаемое значение:
// ДвоичныеДанные  - байты драйвера
//
Функция ПолучитьДвоичныеДанныеДрайвера(ИмяМакета) Экспорт
	ДвоичныеДанные=ПолучитьОбщийМакет(ИмяМакета);
	Если ТипЗнч(ДвоичныеДанные)=Тип("ДвоичныеДанные") Тогда
	Возврат ДвоичныеДанные;	
	КонецЕсли;
	Возврат новый ДвоичныеДанные(Неопределено);
КонецФункции


Процедура  ПодтвердитьУстановкуКомпаненты() Экспорт 
	Константы.КомпонентаУстановленна.Установить(Истина);
КонецПроцедуры
// Функция - Компанента сканирования установлена
// 
// Возвращаемое значение:
//  Булево - Значение константы "КомпонентаУстановленна" 
//
Функция КомпанентаСканированияУстановлена()Экспорт 
	Возврат Константы.КомпонентаУстановленна.Получить();
КонецФункции
// Функция - Сформировать структуру инициализации данных
//
// Параметры:
//  СтруктураОтвета			 - Структура - структура данных содержащая обязательные поля.
//  * ИдЗадачи - УникальныйИдентификатор - уникальный идентификатор задачи ТСД
//  * ТипЗадачи - Перечисления.итWMSТипыЗадачТСД - тип инициализируемой задачи
//  * ФиксацияЗадачи - Булево - определяет конечное ли это состояние для текущей задачи
//  ТипИнициализации		 - Строка - Описания типа инициализации. 
//  Пример: "Задача","Документ","ЗадачаОтказ","ДокументОтказ". 
//  СостояниеИнициализации	 - Перечисления.итWMSСостоянияЗадачТСД	 -  состояние в которое задача будет переведена после инициализации
// 
// Возвращаемое значение:
// Структура - СтруктураДанных с заполненными свойствами на основе входящих параметров.
//
Функция СформироватьСтруктуруИнициализацииДанных(СтруктураОтвета,ТипИнициализации,СостояниеИнициализации) Экспорт 
	СтруктураДанных =новый Структура;
	СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
	СтруктураДанных.Вставить("КлючИнициализацииДанных",СтруктураОтвета.ИдЗадачи);
	СтруктураДанных.Вставить("ТипЗадачи",СтруктураОтвета.ТипЗадачи);
	СтруктураДанных.Вставить("ТипИнициализации",ТипИнициализации);
	СтруктураДанных.Вставить("СостояниеИнициализации",СостояниеИнициализации);
	СтруктураДанных.Вставить("Инициализация",Ложь);
	Если СтруктураОтвета.Свойство("ФиксацияЗадачи") тогда
		СтруктураДанных.Вставить("ФиксацияЗадачи",СтруктураОтвета.ФиксацияЗадачи);
	иначе
		СтруктураДанных.Вставить("ФиксацияЗадачи",ложь);
	КонецЕсли;
	Возврат СтруктураДанных;
КонецФункции

// Функция - Пустой уникальный идентификатор
// 
// Возвращаемое значение:
// УникальныйИдентификатор  - уникальный идентификатор вида "00000000-0000-0000-0000-000000000000"
//
Функция ПустойУникальныйИдентификатор() Экспорт 
	Возврат новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
КонецФункции
// Функция - Поиск элемента структурированного массива по ключу
//
// Параметры:
//  Массив				 - Массив - структурированный массив 
//  Ключ				 - Строка - Имя свойства в структурированном массиве
//  ЗначениеСравнения	 - Произвольный	 - Значение свойства, которое необходимо найти
// 
// Возвращаемое значение:
//  Число,Неопределено - Индекс строки массива, в котором находится искомое значение
//
Функция ПоискЭлементаСтруктурированногоМассиваПоКлючу(Массив,Ключ,ЗначениеСравнения) Экспорт 
	Индекс=0;
	для Каждого стр из Массив цикл
		Если стр[Ключ]=ЗначениеСравнения тогда
			Возврат Индекс;
		КонецЕсли;
		Индекс=Индекс+1;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции
// Процедура - Преобразовать таблицу с идентификаторами для чтения запроса.
// Все колонки с типом  УникальныйИдентификатор будут продублированные по шаблону "#НаименованиеКолонки#"+"Представление" и в них будет помещено
// строковое представление уникального идентификатора из колонки с именем "#НаименованиеКолонки#"
// Исключение если колонка с именем "#НаименованиеКолонки#"+"Представление" уже существует , то колонка с именем "#НаименованиеКолонки#" - не дублируется.  
// Параметры:
//  Таблица	 - ТаблицаЗначений - таблица значений для анализа и добавления колонок 
//
Процедура ПреобразоватьТаблицуСИдентификаторамиДляЧтенияЗапроса(Таблица) Экспорт 
	МассивСтолбцовПодЗамену=новый Массив;
	Для Каждого Колонка из Таблица.Колонки цикл
		Если Колонка.ТипЗначения.СодержитТип(Тип("УникальныйИдентификатор")) тогда
			МассивСтолбцовПодЗамену.Добавить(Колонка.Имя);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Элемент из МассивСтолбцовПодЗамену цикл
		Если Таблица.Колонки.Найти(Элемент+"Представление")=Неопределено Тогда 
		Таблица.Колонки.Добавить(Элемент+"Представление",новый ОписаниеТипов("Строка",,,,новый КвалификаторыСтроки(36),,));
		КонецЕсли;
	КонецЦикла;
	Для Каждого стр из Таблица цикл
		Для Каждого Элемент из МассивСтолбцовПодЗамену цикл
			стр[Элемент+"Представление"]=Строка(стр[Элемент]);
        КонецЦикла;
    КонецЦикла;
КонецПроцедуры

// Функция - Получить18 символьный SSCC Из 20
//
// Параметры:
//  SSCCВходящий - Строка - номер паллеты 
// 
// Возвращаемое значение:
// Строка  - Если номер паллеты имел 20 символов среди которых первые два- "00", то эти 2 нуля будут удалены.
//
Функция Получить18СимвольныйSSCCИз20(SSCCВходящий) Экспорт 
	SSCC=SSCCВходящий;
	Если СтрДлина(SSCC)=20  тогда
		Если Лев(SSCC,2)="00" Тогда 
			//Приведение к 20 к 18 символам (костыль из за заводов)
			SSCC=Прав(SSCC,18);
			//
		КонецЕсли;
	КонецЕсли;
    Возврат SSCC;
	КонецФункции
// Функция - Split
//
// Параметры:
//  Строка		 - Строка - Строка для разбиения на массив 
//  Разделитель	 - Строка - Признак разбиения на массив 
// 
// Возвращаемое значение:
// Массив  - Массив подстрок 
//
Функция Split(Строка, Разделитель) Экспорт
       м=Новый Массив;
       с=СтрЗаменить(СокрЛП(Строка), Разделитель, Символы.ПС);
       Для к=1 По СтрЧислоСтрок(с) Цикл
              Слово= СокрЛП(СтрПолучитьСтроку(с,к)); //Заодно
               // убрать лишние пробелы
               Если СтрДлина(Слово)>0 Тогда //См. примечание
                      м.Добавить(Слово);
               КонецЕсли;
        КонецЦикла;
        Возврат м;
КонецФункции
// Процедура - Установить идентификатор базы
// устанавливает значение констаны ИдентификаторБазы 
// Параметры:
//  Идентификатор	 - Строка - идентификатор базы (ГУИД) полученный методом ИдентификаторБазыНачалоВыбора в модуле МодульМобильныхДивайсовКлиент 
//
Процедура УстановитьИдентификаторБазы(Идентификатор)Экспорт 
Константы.ИдентификаторБазы.Установить(Идентификатор);	
КонецПроцедуры
// Функция - Получить значение идентификатора базы
// 
// Возвращаемое значение:
// Строка  - возвращает идентификатор базы , полученный при установки драйверов  
//
Функция ПолучитьЗначениеИдентификатораБазы() Экспорт 
	Возврат Константы.ИдентификаторБазы.Получить();	
КонецФункции

Процедура ЗаписьСервесныхДанныхВКонстанты(Данные) Экспорт 
	МассивСтроки=Split(Данные,"*&*");
	Если МассивСтроки.Количество()=3 Тогда 
		Константы.СерийныйНомерТСД.Установить(МассивСтроки[0]);
		Константы.МодельТСД.Установить(МассивСтроки[1]);
	    ЭлементОтсечки=Найти(МассивСтроки[2],"EndDescription");
		Если ЭлементОтсечки>0  Тогда 
		Константы.ВерсияОС.Установить(Лев(МассивСтроки[2],ЭлементОтсечки-1));
			иначе
        Константы.ВерсияОС.Установить(МассивСтроки[2]);
		КонецЕсли;
	КонецЕсли;
	ПараметрыСеанса.ТСДИД=МассивСтроки[0];
	КонецПроцедуры

Функция ПолучитьМодельТСД() Экспорт 
	Возврат Константы.МодельТСД.Получить();
	КонецФункции
	
#Область ЛогированиеДанныхТСД
Процедура ОчисткаЛогаЗаСутки() Экспорт 
	Попытка
		СтруктураДанных=новый Структура;
		СтруктураДанных.Вставить("КлючОперации","ДатаВремяСервера");
		СтруктураДанных=ОбработчикиЗапросаСервера.ЗапросДатыСервера(СтруктураДанных);
		ТиповойОбработчикОшибок(СтруктураДанных,"ДатаВремяСервера");
		ДатаОчистки=СтруктураДанных.ДатаВремяСервера-(60*60*24);
		ПараметрыСеанса.ДатаВремяСервера=СтруктураДанных.ДатаВремяСервера;
        ПараметрыСеанса.ВременнаяРазница=ПараметрыСеанса.ДатаВремяСервера-ТекущаяДатаСеанса();
	Исключение
		Возврат
	КонецПопытки;
	//ДатаОчистки=ТекущаяДата()-(60*60*24);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛогРаботыТСД.КлючОперации КАК КлючОперации,
	|	ЛогРаботыТСД.ДатаОперации КАК ДатаОперации,
	|	ЛогРаботыТСД.КлючЗаписи КАК КлючЗаписи
	|ИЗ
	|	РегистрСведений.ЛогРаботыТСД КАК ЛогРаботыТСД
	|ГДЕ
	|	(ЛогРаботыТСД.ДатаОперации <= &ДатаОчистки
	|			ИЛИ ЛогРаботыТСД.ДатаОперации >= ДОБАВИТЬКДАТЕ(&ДатаОчистки, ДЕНЬ, 2))";
	
	Запрос.УстановитьПараметр("ДатаОчистки", ДатаОчистки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МенеджерЗаписи=РегистрыСведений.ЛогРаботыТСД.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ДатаОперации=ВыборкаДетальныеЗаписи.ДатаОперации;
		МенеджерЗаписи.КлючОперации=ВыборкаДетальныеЗаписи.КлючОперации;
		МенеджерЗаписи.КлючЗаписи=ВыборкаДетальныеЗаписи.КлючЗаписи;
		МенеджерЗаписи.Прочитать();
		МенеджерЗаписи.Удалить();	
	КонецЦикла;
	
	
	
КонецПроцедуры

Процедура ДобавитьВЛог(КлючДанных=Неопределено,Событие="",ДополнительныйКлюч="") Экспорт
	Если ПараметрыСеанса.ДатаВремяСервера='00010101'  Тогда 
		СтруктураДанных=новый Структура;
		СтруктураДанных.Вставить("КлючОперации","ДатаВремяСервера");
		СтруктураДанных=ОбработчикиЗапросаСервера.ЗапросДатыСервера(СтруктураДанных);
		ТиповойОбработчикОшибок(СтруктураДанных,"ДатаВремяСервера");
		ПараметрыСеанса.ДатаВремяСервера=СтруктураДанных.ДатаВремяСервера;
		ПараметрыСеанса.ВременнаяРазница=ПараметрыСеанса.ДатаВремяСервера-ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если КлючДанных=Неопределено Тогда 
		КлючДанных=новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	КонецЕсли;
	МенеджерЗаписи=РегистрыСведений.ЛогРаботыТСД.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ДатаОперации=ТекущаяДатаСеанса()+ПараметрыСеанса.ВременнаяРазница;
	МенеджерЗаписи.КлючОперации=КлючДанных;
	МенеджерЗаписи.КлючЗаписи=новый УникальныйИдентификатор;
	МенеджерЗаписи.Событие=Событие;
	МенеджерЗаписи.ДатаВМилисекундах=ТекущаяУниверсальнаяДатаВМиллисекундах()+(ПараметрыСеанса.ВременнаяРазница*1000);
	МенеджерЗаписи.ДополнительныйКлюч=ДополнительныйКлюч;
	МенеджерЗаписи.Записать(Истина);
КонецПроцедуры

Процедура ОтправитьЛогНаСервер()Экспорт 
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛогРаботыТСД.КлючОперации КАК КлючОперации,
		|	ЛогРаботыТСД.ДатаОперации КАК ДатаОперации,
		|	ЛогРаботыТСД.КлючЗаписи КАК КлючЗаписи,
		|	ЛогРаботыТСД.Событие КАК Событие,
		|	ЛогРаботыТСД.ДополнительныйКлюч КАК ДополнительныйКлюч,
		|	ЛогРаботыТСД.ДатаВМилисекундах КАК ДатаВМилисекундах
		|ИЗ
		|	РегистрСведений.ЛогРаботыТСД КАК ЛогРаботыТСД
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаОперации,
		|	КлючЗаписи,
		|	КлючОперации,
		|	ДополнительныйКлюч,
		|	Событие,
		|	ДатаВМилисекундах";
	
	ДанныеЛога = Запрос.Выполнить().Выгрузить();
	
	
	СтруктураДанных=новый Структура;
	СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
	СтруктураДанных.Вставить("КлючОперации","ЗаписьЛогаДляТСД");
	СтруктураДанных.Вставить("ДанныеЛога",ДанныеЛога);
	СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"ServiceFunction");
	Если не ТиповойОбработчикОшибок(СтруктураДанных) тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Лог отправлен");
	КонецЕсли;
	КонецПроцедуры
#КонецОбласти
Процедура УдалениеРегистрацииТСД()Экспорт 
	СтруктураДанных=новый Структура;
	СформироватьСтруктуруДанныхОПользователе(СтруктураДанных);
	СтруктураДанных.Вставить("КлючОперации","УдалениеРегистрацииТСД");
	СтруктураДанных=ОбработчикиЗапросаСервера.ЗапроситьДанные(СтруктураДанных,"ServiceFunction");
    ТиповойОбработчикОшибок(СтруктураДанных);
	КонецПроцедуры
	
#Область ПроверкаНаЛеквидностьSSCC_GTIN
// Процедура - Проверить SSCCНа леквидность
// Процедура проверяет идентификатор паллеты на соотв. нормам RAR , если не соотв. то отказ принимает значение "ИСТИНА" 
// Параметры:
//  SSCC	 - Строка - идентификатор паллеты(упаковки)
//  Отказ	 - Булево - флаг отказа
//  Сообщать - Булево - если истина, то выдается сообщение пользователю об ошибке
//

Процедура ПроверитьSSCCНаЛеквидность(SSCC,Отказ,Сообщать=Истина) Экспорт 
	Проверка=Ложь;
	ПроверкаНаSSCC20_18(SSCC,Проверка,Сообщать);
	ПроверкаНаSSCCRAR(SSCC,Проверка,Сообщать);
	Если не Проверка тогда
		Отказ=Истина;
	КонецЕсли;	
	
КонецПроцедуры
// Процедура - Проверка на SSCC 20-18
// проверят соотв. SSCC 20-18 символьному формату упаковки согласно RAR
// Параметры:
//  SSCC	 - Строка - идентификатор паллеты(упаковки)
//  Проверка - Булево - Установить в начальное положение ЛОЖЬ - истина - значит проверка пройдена 
//  Сообщать - Булево - если истина, то выдается сообщение пользователю об ошибке
//

Процедура ПроверкаНаSSCC20_18(SSCC,Проверка,Сообщать)
	Ошибка=Истина;
	Если СтрДлина(SSCC)=20 тогда
	Если Лев(SSCC,2)<>"00" тогда
		Возврат
	КонецЕсли;
		Ошибка=Ложь;
	КонецЕсли;
	Если СтрДлина(SSCC)=18 тогда
		Ошибка=Ложь;
		///////отключение проверки 18 сивольного SSCC
		Проверка=Истина;
		Возврат;
		//////////////////
	КонецЕсли;
	Если Ошибка тогда
		Возврат
	КонецЕсли;	
	SSCCБезКонтрольнойЦифры=Лев(SSCC,СтрДлина(SSCC)-1);
	КонтрольнаяЦифраВSSCC=Прав(SSCC,1);
	ДанныеРасчетаКонтрольнойЦифры=ПолучитьКонтрольнуюЦифруШтрихКода(SSCCБезКонтрольнойЦифры);
	Если  СокрЛП(НРег(КонтрольнаяЦифраВSSCC))=СокрЛП(НРег(ДанныеРасчетаКонтрольнойЦифры)) тогда
		Проверка=Истина;
	КонецЕсли;	
		
КонецПроцедуры
// Процедура - Проверка на SSCCRAR
//  проверят соотв. SSCC 26 символьному формату упаковки согласно RAR
// Параметры:
//  SSCC	 - Строка - идентификатор паллеты(упаковки)
//  Проверка - Булево - Установить в начальное положение ЛОЖЬ - истина - значит проверка пройдена 	
//  Сообщать - Булево - если истина, то выдается сообщение пользователю об ошибке
//

Процедура ПроверкаНаSSCCRAR(SSCC,Проверка,Сообщать)
	Если СтрДлина(СокрЛП(SSCC)) <> 26  тогда
		Возврат
	КонецЕсли;
	ЗначениеЛогистическойЕденицы=Сред(СокрЛП(SSCC),13,1);
	Попытка
		ЧислоЛогистическойЕденицы=	Число(ЗначениеЛогистическойЕденицы);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("не читается логистическая еденица");
		Возврат
	КонецПопытки;
	Если ЧислоЛогистическойЕденицы=1 или ЧислоЛогистическойЕденицы=3 тогда
		Если Сообщать Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Вы считываете идентификатор короба, отказано в присвоении паллеты");
		КонецЕсли;
		Возврат
	КонецЕсли;		
	Если ЧислоЛогистическойЕденицы=2 или ЧислоЛогистическойЕденицы=4   тогда
		Проверка = Истина;
	КонецЕсли;
	//ДатаSSCC=Сред(СокрЛП(SSCC),20,6);
	//ЛогистическийНомер=Сред(СокрЛП(SSCC),26,6);
	//ИдентификаторУпаковки=Сред(СокрЛП(SSCC),32,1);
	//Попытка
	//ГодSSCC="20"+Прав(ДатаSSCC,2);
	//Месяц=Сред(ДатаSSCC,3,2);
	//День=Лев(ДатаSSCC,2);
	//ДатаSSCC=Дата(ГодSSCC+Месяц+День);
	//Исключение
	//	Возврат
	//КонецПопытки;	
	КонецПроцедуры
// Функция - Получить контрольную цифру штрих кода
//
// Параметры:
//  ШтрихКод - Строка - любой штрих код , формат которого подразумевает наличие контрольной цифры.  
// 
// Возвращаемое значение:
// Строка - Контрольная цифра строкой.
//
	
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
// Функция - Посчитать сумму цифр на четных местах
//
// Параметры:
//  ДлинаШтрихКода	 - Число 
//  ШтрихКод		 - Строка	
// 
// Возвращаемое значение:
// Число  - Сумма цифр на четных местах 
//

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
// Функция - Получить сумму цифр на нечетных местах
//
// Параметры:
//  ДлинаШтрихКода	 - Число 
//  ШтрихКод		 - Строка	
// 
// Возвращаемое значение:
// Число  - Сумма цифр на не четных местах 
//
	
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
// Процедура - Проверить GTINНа леквидность
// проверка того, что идентификатор короба соотв. 26 симвоьному формату RAR
// Параметры:
//  GTIN	 - Строка - идентификатор короба к проверке
//  Отказ	 - Булево -  флаг отказа 
//  Сообщать - Булево -  если истина, то выдается сообщение пользователю об ошибке
//

Процедура ПроверитьGTINНаЛеквидность(GTIN,Отказ,Сообщать=Истина) Экспорт 
	Проверка=Ложь;
	ПроверкаНаGTINRAR(GTIN,Проверка,Сообщать);
	Если не Проверка тогда
		Отказ=Истина;
	КонецЕсли;	
	
КонецПроцедуры
// Процедура - Проверка на GTINRAR
//  проверка того, что идентификатор короба соотв. 26 симвоьному формату RAR
// Параметры:
//  GTIN	 - Строка - идентификатор короба к проверке
//  Отказ	 - Булево -  флаг отказа 
//  Сообщать - Булево -  если истина, то выдается сообщение пользователю об ошибке
//
Процедура ПроверкаНаGTINRAR(GTIN,Проверка,Сообщать)
	Если СтрДлина(СокрЛП(GTIN)) <> 26  тогда
		Возврат
	КонецЕсли;
	ЗначениеЛогистическойЕденицы=Сред(СокрЛП(GTIN),13,1);
	Попытка
		ЧислоЛогистическойЕденицы=	Число(ЗначениеЛогистическойЕденицы);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("не читается логистическая еденица");
		Возврат
	КонецПопытки;
	Если ЧислоЛогистическойЕденицы=1 или ЧислоЛогистическойЕденицы=3 тогда
		Проверка = Истина;
	КонецЕсли;		
	Если ЧислоЛогистическойЕденицы=2 или ЧислоЛогистическойЕденицы=4   тогда
		Если Сообщать Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Вы считываете идентификатор Паллеты, отказано в присвоении Короба");
		КонецЕсли;
		Возврат
	КонецЕсли;

	КонецПроцедуры

#КонецОбласти

#Область РаботаСНеТиповымВременнымХранилищем
// Функция - Поместить во временное хранилище формы
// Сохраняет данные под ключом УникальныйИД, при окончании жизни формы , удаляет данные, в случае ошибки да
// данные будут удалены при следующем перезапуске приложения
// Параметры:
//  Данные		 - Произвольный	- произвольные данные  
//  УникальныйИД - УникальныйИдентификатор,Строка - строковое значение используется лишь для перезаписи , уже имеющися данных.  
//  Первая запись осуществляется по УникальныйИД с типом УникальныйИдентификатор.
//
// Возвращаемое значение:
// Строка  - Адрес записи - для получения и перезаписи данных.
//

Функция ПоместитьВоВременноеХранилищеФормы(Данные,УникальныйИД) Экспорт
	Если ТипЗнч(УникальныйИД)=тип("УникальныйИдентификатор") или  Найти(УникальныйИД,"ВременноеХранилищеФорм") тогда
		
		ХранилищеЗначений= новый ХранилищеЗначения(Данные);
		МенеджерЗаписи=РегистрыСведений.ВременноеХранилищеФорм.СоздатьМенеджерЗаписи();
		Если ТипЗнч(УникальныйИД)=тип("УникальныйИдентификатор") тогда
			АдресПомещения=Строка(новый УникальныйИдентификатор)+"ВременноеХранилищеФорм";
			МенеджерЗаписи.Адрес=АдресПомещения;
			МенеджерЗаписи.УникальныйИдФормы=УникальныйИД;
		иначе
			МенеджерЗаписи.Адрес=УникальныйИД;
			МенеджерЗаписи.УникальныйИдФормы=ПолучитьУникальныйИдФормыПоАдресу(УникальныйИД);
			МенеджерЗаписи.Прочитать();
		КонецЕсли;
		МенеджерЗаписи.Данные=ХранилищеЗначений;
		МенеджерЗаписи.Записать();
		Возврат МенеджерЗаписи.Адрес;
	иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указан адрес хранилища");
		Возврат "";
	КонецЕсли;
КонецФункции
// Функция - Получить уникальный ид формы по адресу
//
// Параметры:
//  Адрес	 - Строка - Адрес вида "#УникальныйИдентификатор#"+"ВременноеХранилищеФорм".
// 
// Возвращаемое значение:
// УникальныйИдентификатор  - УникальныйИдентификатор формы , используемый как адрес хранения данных 
//

Функция ПолучитьУникальныйИдФормыПоАдресу(Адрес)
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВременноеХранилищеФорм.УникальныйИдФормы КАК УникальныйИдФормы
	|ИЗ
	|	РегистрСведений.ВременноеХранилищеФорм КАК ВременноеХранилищеФорм
	|ГДЕ
	|	ВременноеХранилищеФорм.Адрес = &Адрес";
	
	Запрос.УстановитьПараметр("Адрес", Адрес);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() тогда
		Возврат ВыборкаДетальныеЗаписи.УникальныйИдФормы;
	КонецЕсли;
	Возврат Неопределено
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции
// Функция - Получить из временного хранилища формы
//
// Параметры:
//  Адрес	 - Строка - Адрес вида "#УникальныйИдентификатор#"+"ВременноеХранилищеФорм".
// 
// Возвращаемое значение:
// Произвольный  - данные хранилища  
//

Функция ПолучитьИзВременногоХранилищаФормы(Адрес)Экспорт
	МенеджерЗаписи = РегистрыСведений.ВременноеХранилищеФорм.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Адрес= Адрес;
	МенеджерЗаписи.УникальныйИдФормы=ПолучитьУникальныйИдФормыПоАдресу(Адрес);
	МенеджерЗаписи.Прочитать();
	Возврат МенеджерЗаписи.Данные.Получить();
КонецФункции
// Процедура - При закрытии формы временное хранилище
// Производит удаление данных сохраненных под УИД формы
// Параметры:
//  УникальныйИД - УникальныйИдентификатор - Уникальный Идентификатор формы используеимый для хранения данных
//

Процедура ПриЗакрытииФормыВременноеХранилище(УникальныйИД) Экспорт 
	НаборЗаписей=РегистрыСведений.ВременноеХранилищеФорм.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УникальныйИдФормы.Установить(УникальныйИД);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	НаборЗаписей.Записать();
КонецПроцедуры
// Процедура - Очистить все хранилища при открытии программы
// Производит удаление данных сохраненных под УИД формы,оставшихся от предыдущих сеансов из за каких либо сбоев.

Процедура ОчиститьВсеХранилищаПриОткрытииПрограммы() Экспорт 
	НаборЗаписей=РегистрыСведений.ВременноеХранилищеФорм.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	НаборЗаписей.Записать();
КонецПроцедуры
#КонецОбласти

#Область РаботаСоШтрихКодами
// Функция - Получить данные из ит задачи ТСД
// Функция получает данные задачи по штрих коду  из поля "ИдентификаторУпаковки" в регистре
// Параметры:
//  ШтрихКод - Строка - Штрих код , по которому осуществляется поиск задачи - чаще всего Идентификатор упаковки(SSCC)
//  ДокументОснование - Произвольный - Ссылка на документ, которому принадлежит задача (не обязательный)  уточняющий параметр
//
// Возвращаемое значение:
// Структура - Структура содержащая в себе данные задачи. 
//
Функция ПолучитьДанныеИзИтЗадачиТСД(ШтрихКод,ДокументОснование=Неопределено) Экспорт 
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.ИдЗадачи КАК ИдЗадачи,
	|	ИтСтрокиЗадачНаТСД.ИдСтроки КАК ИдСтроки,
	|	ИтСтрокиЗадачНаТСД.Номенклатура КАК Номенклатура,
	|	ИтСтрокиЗадачНаТСД.НоменклатураПредставление КАК НоменклатураПредставление,
	|	ИтСтрокиЗадачНаТСД.ДатаРозлива КАК ДатаРозлива,
	|	ИтСтрокиЗадачНаТСД.СерияНоменклатуры КАК СерияНоменклатуры,
	|	ИтСтрокиЗадачНаТСД.СерияНоменклатурыПредставление КАК СерияНоменклатурыПредставление,
	|	ИтСтрокиЗадачНаТСД.Количество КАК Количество,
	|	ВложенныйЗапрос.ЯчейкаОтправитель КАК ЯчейкаОтправитель,
	|	ВложенныйЗапрос.ЯчейкаОтправительПредставление КАК ЯчейкаОтправительПредставление,
	|	ВложенныйЗапрос.ЯчейкаПолучатель КАК ЯчейкаПолучатель,
	|	ВложенныйЗапрос.ЯчейкаПолучательПредставление КАК ЯчейкаПолучательПредставление,
	|	ВложенныйЗапрос.Состояние КАК Состояние,
	|	ВложенныйЗапрос.ДокументОснование КАК ДокументОснование,
	|	ВложенныйЗапрос.ТипЗадачи КАК ТипЗадачи,
	|	ВложенныйЗапрос.ИдентификаторУпаковки КАК ИдентификаторУпаковки
	|ИЗ
	|	(ВЫБРАТЬ
	|		ИтЗадачиНаТСД.ЯчейкаОтправитель КАК ЯчейкаОтправитель,
	|		ИтЗадачиНаТСД.ЯчейкаОтправительПредставление КАК ЯчейкаОтправительПредставление,
	|		ИтЗадачиНаТСД.ЯчейкаПолучатель КАК ЯчейкаПолучатель,
	|		ИтЗадачиНаТСД.ЯчейкаПолучательПредставление КАК ЯчейкаПолучательПредставление,
	|		ИтЗадачиНаТСД.Состояние КАК Состояние,
	|		ИтЗадачиНаТСД.ИдЗадачи КАК ИдЗадачи,
	|		ИтЗадачиНаТСД.ДокументОснование КАК ДокументОснование,
	|		ИтЗадачиНаТСД.ТипЗадачи КАК ТипЗадачи,
	|		ИтЗадачиНаТСД.ИдентификаторУпаковки КАК ИдентификаторУпаковки
	|	ИЗ
	|		РегистрСведений.ИтЗадачиНаТСД КАК ИтЗадачиНаТСД
	|	ГДЕ
	|		ИтЗадачиНаТСД.ИдентификаторУпаковки = &ШтрихКод
	|		И ИтЗадачиНаТСД.Состояние <> ЗНАЧЕНИЕ(Перечисление.итWMSСостоянияЗадачТСД.ОжидаетРазрешения)
	|		И ВЫБОР
	|				КОГДА &ДокументОснование = НЕОПРЕДЕЛЕНО
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ИтЗадачиНаТСД.ДокументОснование = &ДокументОснование
	|			КОНЕЦ) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИтСтрокиЗадачНаТСД КАК ИтСтрокиЗадачНаТСД
	|		ПО ВложенныйЗапрос.ИдЗадачи = ИтСтрокиЗадачНаТСД.ИдЗадачи
	|ИТОГИ
	|	МАКСИМУМ(ЯчейкаОтправитель),
	|	МАКСИМУМ(ЯчейкаОтправительПредставление),
	|	МАКСИМУМ(ЯчейкаПолучатель),
	|	МАКСИМУМ(ЯчейкаПолучательПредставление),
	|	МАКСИМУМ(Состояние),
	|	МАКСИМУМ(ДокументОснование),
	|	МАКСИМУМ(ИдентификаторУпаковки)
	|ПО
	|	ТипЗадачи,
	|	ИдЗадачи";
	
	//Запрос.УстановитьПараметр("ДокументОснование", Объект.Ссылка);
	//Запрос.УстановитьПараметр("ТипЗадачи", Объект.ТипЗадачи);
	Запрос.УстановитьПараметр("ШтрихКод", ШтрихКод);
	Запрос.УстановитьПараметр("ДокументОснование",ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	СтруктураОтвета = новый Структура;
	Если РезультатЗапроса.Пустой() тогда
		СтруктураОтвета.Вставить("Статус",404);
		СтруктураОтвета.Вставить("ОписаниеОшибки","этого штрих-кода нет в активной части задач");
	КонецЕсли;
	ВыборкаТипаЗадачи=РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	пока ВыборкаТипаЗадачи.Следующий() цикл
		ПредставлениеТипаЗадачи=ПредставлениеТипаЗадачиТСД(ВыборкаТипаЗадачи.ТипЗадачи);
		СтруктураОтвета.Вставить(ПредставлениеТипаЗадачи);
		ВыборкаЗадачи =ВыборкаТипаЗадачи.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам); 	
		пока ВыборкаЗадачи.Следующий() цикл
			СтруктураЗадачи=новый Структура;
			СтруктураЗадачи.Вставить("ИдЗадачи",ВыборкаЗадачи.ИдЗадачи);
			СтруктураЗадачи.Вставить("ЯчейкаОтправитель",ВыборкаЗадачи.ЯчейкаОтправитель);
			СтруктураЗадачи.Вставить("ЯчейкаОтправительПредставление",ВыборкаЗадачи.ЯчейкаОтправительПредставление);
			СтруктураЗадачи.Вставить("ИдентификаторУпаковки",ВыборкаЗадачи.ИдентификаторУпаковки);
			СтруктураЗадачи.Вставить("ТипЗадачи",ВыборкаЗадачи.ТипЗадачи);
			СтруктураЗадачи.Вставить("ДокументОснование",ВыборкаЗадачи.ДокументОснование);
			СтруктураЗадачи.Вставить("ЯчейкаПолучатель",ВыборкаЗадачи.ЯчейкаПолучатель);
			СтруктураЗадачи.Вставить("ЯчейкаПолучательПредставление",ВыборкаЗадачи.ЯчейкаПолучательПредставление);
			СтруктураЗадачи.Вставить("Состояние",ВыборкаЗадачи.Состояние);
			
			ВыборкаДетальныеЗаписи=ВыборкаЗадачи.Выбрать();
			МассивСтрок=новый Массив;
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				СтруктураСтрокЗадачи=новый Структура;
				для Каждого Колонка из РезультатЗапроса.Колонки цикл
					СтруктураСтрокЗадачи.Вставить(Колонка.Имя,ВыборкаДетальныеЗаписи[Колонка.Имя]);
				КонецЦикла;
				МассивСтрок.Добавить(СтруктураСтрокЗадачи);
			КонецЦикла;
			СтруктураЗадачи.Вставить("МассивСтрок",МассивСтрок);
		КонецЦикла;
		СтруктураОтвета[ПредставлениеТипаЗадачи]=СтруктураЗадачи;
	КонецЦикла;
	
	Возврат СтруктураОтвета;
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции
#КонецОбласти