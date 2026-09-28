export const SITE_NAME = process.env.NEXT_PUBLIC_SITE_NAME ?? '玄机在线';
export const SITE_NAME_EN = process.env.NEXT_PUBLIC_SITE_NAME_EN ?? 'Xuanji Online';
export const SITE_TAGLINE = process.env.NEXT_PUBLIC_SITE_TAGLINE ?? '将传统命理文化与前沿AI技术深度融合';

export function siteBranding() {
  return {
    name: SITE_NAME,
    nameEn: SITE_NAME_EN,
    tagline: SITE_TAGLINE,
  };
}
