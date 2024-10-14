let initTooltips = doc => {
  let elems = doc.body.querySelectorAll('[title]')

  elems.forEach(x => {
    x.setAttribute('title', x.getAttribute('title')
                             .replaceAll('{{today}}', new Date().toISOString().slice(0, 10)));
  });

  tippy(elems, {
    allowHTML:   true,
    interactive: true,
    placement:   'bottom',
    theme:       'light',
    content(reference) {
        let title = reference.getAttribute('title');
        reference.removeAttribute('title');
        return title;
    }
  });
};

let getSelectedBaseInterval = doc =>
  [...doc.querySelectorAll('#template option')].find(x => x.getAttribute('value') == x.parentElement.value)
                                                           .getAttribute('data-baseInterval');

let parseFI = date => date.toLocaleString('fi-FI', {year: 'numeric', month: '2-digit', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', timeZone: 'Europe/Helsinki', timeZoneName: 'longOffset'}).match(/(\d+).(\d+).(\d\d\d\d) klo (\d+).(\d+).(\d+) UTC([+-.0-9]+)/);

let pad2 = x => new String(x).padStart(2, '0')

let formatInFI = date => {
  [_, day, month, year, hour, minute, _, _] = parseFI(date);
  return `${year}-${pad2(month)}-${pad2(day)} ${pad2(hour)}:${pad2(minute)}`;
}

let formatDateInFI = date => {
  [_, day, month, year, _, _, _, _] = parseFI(date);
  return `${year}-${pad2(month)}-${pad2(day)}`;
}

let formatTimeInFI = date => {
  [_, _, _, _, hour, minute, _, _] = parseFI(date);
  return `${pad2(hour)}:${pad2(minute)}`;
}

let formatInFIWithHourAndMinute = hourAndMinute => date => {
  [_, day, month, year, _, _, _, offset] = parseFI(date);
  return new Date(`${year}-${pad2(month)}-${pad2(day)}T${hourAndMinute}:00${offset.replace('.', ':')}`);
}