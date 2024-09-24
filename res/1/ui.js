let initTooltips = doc => {
  let elems = doc.body.querySelectorAll('[title]')

  elems.forEach(x => {
    x.setAttribute('title', x.getAttribute('title')
                             .replaceAll('{{today}}', new Date().toISOString().slice(0, 10)));
  });

  tippy(elems, {
    allowHTML:   true,
    interactive: true,
    placement:   'auto',
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

let readInterval = dateFns => {
  if (window.location.hash) {
    let ret = window.location.hash.split("#").find(x => {
      let times = x.substring(1).split('/').map(x => new Date(x));
      if (times.length == 2 && !isNaN(times[0]) && !isNaN(times[1])) {
        return {start: times[0], end: times[1]};
      }
    });
    if (ret) {
      return ret;
    }
  }
  return {start: dateFns.addMonths(new Date(), -1), end: dateFns.addDays(new Date(), 2)};
};

let initQuery = (dateFns, elem) => {
  let interval = readInterval(dateFns);
  elem.value = elem.value.replace("{start}", interval.start.toISOString())
                         .replace("{end}",   interval.end.toISOString());
};

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