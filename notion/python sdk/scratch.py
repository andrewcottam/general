import os
from notion_client import Client

notion = Client(auth="secret_wrzqXR0C5czfkd7wNchw3onb1gm03FuTcctBTscHrx3")
my_page = notion.databases.query(
    **{
        "database_id": "251044d22d654e43a217fb1150b51600",
        "filter": {
            "property": "Wibble",
            "rich_text": {
                "contains": "else",
            },
        },
    }
)
print(my_page['results'][0]['properties'])