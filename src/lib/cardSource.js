/**
 * Pokémon TCG Pocket includes legacy TCGdex and candidate-owned rows. Japanese
 * printed cards share the `tcgdex` origin (and `ptcgdb` is Japanese-only), so
 * origin alone must not decide the Pocket label. Matches the Explore
 * Source=Pocket query (tcgdex/pocketdb, origin_detail not 'japanese').
 */
export function isPocketOrigin(origin, originDetail) {
  return (
    POCKET_ORIGINS.includes(String(origin || "").toLowerCase()) &&
    String(originDetail || "").toLowerCase() !== "japanese"
  );
}

export const POCKET_ORIGINS = ["tcgdex", "pocketdb"];
export const CATALOG_ORIGINS = ["pokemontcg.io", "manual", "tcgdex", "ptcgdb", "pocketdb"];

// Shared by page, exact-count and fallback-filter paths.
export function applyPocketSourceFilter(query) {
  return query.in("origin", POCKET_ORIGINS).or("origin_detail.is.null,origin_detail.neq.japanese");
}

export function cardSourceForRow(card) {
  if (card.is_promo) return "Promo";
  if (isPocketOrigin(card.origin, card.origin_detail)) return "Pocket";
  if (card.origin_detail === "japanese") return "TCG (JPN)";
  if (card.origin === "manual") return "Custom";
  return "TCG";
}
