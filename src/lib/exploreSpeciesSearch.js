// Reviewed aliases for National Pokédex #026. Enable new species here after
// reviewing their catalog links. Source: https://pokeapi.co/api/v2/pokemon-species/26/
const raichu = { id: 26, name: "Raichu" };
const aliases = new Map(
  ["raichu", "ライチュウ", "라이츄", "雷丘"].map((name) => [name, raichu])
);

export function resolveExploreSpecies(query) {
  return aliases.get(String(query ?? "").normalize("NFKC").trim().toLowerCase()) ?? null;
}

export function exactExploreCardTitle(query) {
  const match = String(query ?? "").trim().match(/^"([^"]+)"$/u);
  return match?.[1].trim() || null;
}
