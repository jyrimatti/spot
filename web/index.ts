import { createDbWorker } from "sql.js-httpvfs";
import { zonedTimeToUtc, formatInTimeZone } from 'date-fns-tz';
import { addHours, addMonths, addYears, eachDayOfInterval, eachWeekendOfInterval } from 'date-fns';
import {fi} from 'date-fns/locale';

const workerUrl = new URL(
  "sql.js-httpvfs/dist/sqlite.worker.js",
  import.meta.url
);
const wasmUrl = new URL("sql.js-httpvfs/dist/sql-wasm.wasm", import.meta.url);

async function load(db: string, query: string) {
  console.log("Querying " + db + ": " + query);
  const worker = await createDbWorker(
    [
      {
        from: "inline",
        config: {
          serverMode: "full",
          url: db,
          requestChunkSize: 4096,
        },
      },
    ],
    workerUrl.toString(),
    wasmUrl.toString()
  );

  const result = await worker.db.query(query);
  return result;
}

(window as any).load = load;
(window as any).zonedTimeToUtc = zonedTimeToUtc;
(window as any).formatInTimeZone = formatInTimeZone;
(window as any).addHours = addHours;
(window as any).addMonths = addMonths;
(window as any).addYears = addYears;
(window as any).eachDayOfInterval = eachDayOfInterval;
(window as any).eachWeekendOfInterval = eachWeekendOfInterval;
(window as any).fi = fi;
