from dataclasses import dataclass
from typing import *


@dataclass
class MenuOption:
    keys: List[str]
    title: str
    callback: Callable


class Menu:
    def __init__(
            self,
            title: str = '',
            content: str = '',
            options=None,
            title_builder: Optional[Callable[[], str]] = None,
            content_builder: Optional[Callable[[], str]] = None,
            options_builder: Optional[Callable[[], List[MenuOption]]] = None,
            backward_text: Optional[str] = '回到上一级',
            multiple_key_separator: str = '/'):
        if options is None:
            options = []
        if title_builder is None:
            def title_builder():
                return title
        if content_builder is None:
            def content_builder():
                return content
        if options_builder is None:
            def options_builder():
                return options

        self.__title = title_builder
        self.__content = content_builder
        self.__options = options_builder
        self.__has_next_loop = True
        self.__menu_item_dict = dict()
        self.__multiple_key_separator = multiple_key_separator
        self.__backward_text = backward_text

    def __generate_option_key(self):
        """
        生成一遍 key
        """
        for index, option in enumerate(self.__get_options()):
            if len(option.keys) == 0:
                option.keys = [str(index)]
            for key in option.keys:
                self.__menu_item_dict[key] = option

    def __display_title(self):
        """
        显示标题
        """
        print()
        print(self.__title())

    def __display_content(self):
        """
        显示内容
        """
        print(self.__content())

    def __get_options(self):
        if self.__backward_text is not None:
            return self.__options() + [MenuOption(
                keys=['q'],
                title=self.__backward_text,
                callback=self.terminal_next,
            )]
        else:
            return self.__options()

    def __select_option_menu(self):
        """
        选择菜单项
        """
        for option in self.__get_options():
            print(self.__multiple_key_separator.join(
                option.keys), option.title, sep=': ')

        while True:
            key = input('请选择: ')
            if key in self.__menu_item_dict.keys():
                break
            else:
                print('select error', f'cannot found {key}')

        return self.__menu_item_dict[key]

    def __show_once(self):
        """
        用于展示一次菜单
        """

        try:
            self.__display_title()
            self.__display_content()
            select_option = self.__select_option_menu()
            select_option.callback()

        except KeyboardInterrupt as _:
            print()
            print('Exit build script')
            exit(0)

    def terminal_next(self):
        """
        终止下次的菜单循环
        """
        self.__has_next_loop = False

    def loop(self):
        """
        菜单循环
        """
        self.__generate_option_key()
        while self.__has_next_loop:
            self.__show_once()
