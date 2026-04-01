"""Hook module for mkdocs-to-pdf plugin.

Works around a bug in mkdocs-to-pdf 0.10.1 where the generic theme handler's
inject_link() signature doesn't match what the event_hook caller passes.
See: https://github.com/domWalters/mkdocs-to-pdf/issues
"""

from bs4 import BeautifulSoup


def inject_link(html, href, page, logger):
    soup = BeautifulSoup(html, 'html.parser')
    if soup.head:
        link = soup.new_tag(
            'link', href=href, rel='alternate',
            title='PDF', type='application/pdf'
        )
        soup.head.append(link)
        return str(soup)
    return html
