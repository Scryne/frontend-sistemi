// Bazı ağlarda AAAA kaydı olmayan alan adlarında DNS sorgusu ~12 sn sürüyor (router AAAA'ya cevap vermiyor).
// Node'un fetch'i (undici) 10 sn'de bağlantıdan vazgeçtiği için shadcn CLI gibi araçlar kayıt defterine
// ulaşamıyor. Bu ön yükleme dns.lookup'ı IPv4'e zorlar: NODE_OPTIONS="--require <bu dosya>".
const dns = require("dns");
const asil = dns.lookup;
dns.lookup = function (host, opts, cb) {
  if (typeof opts === "function") return asil.call(this, host, { family: 4 }, opts);
  if (typeof opts === "number") opts = { family: opts };
  return asil.call(this, host, { ...opts, family: 4 }, cb);
};
