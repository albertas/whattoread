from unittest.mock import Mock, patch

from whattoread.cli import main

BOOKS_RESP = Mock()
BOOKS_RESP.json.return_value = {
    'results': {
        'books': [
            {'title': 'DARE TO LEAD'},
            {'title': 'RADICAL CANDOR'},
        ]
    }
}


def test_main_success() -> None:
    with patch('whattoread.cli.httpx.get', return_value=BOOKS_RESP):
        assert main() == '1. Dare To Lead\n2. Radical Candor'


def test_main_api_key_is_not_set() -> None:
    with patch('whattoread.cli.os.getenv', return_value=None):
        assert main() == 'Please set NEW_YORK_TIMES_API_KEY environment variable.'
