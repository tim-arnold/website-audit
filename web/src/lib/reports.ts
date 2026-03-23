import { readFileSync, readdirSync, existsSync, statSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
// src/lib → src → web → repo root
const REPO_ROOT = join(__dirname, '..', '..', '..');
const CLIENTS_DIR = join(REPO_ROOT, 'clients');

export const AUDIT_LABELS: Record<string, string> = {
  'seo-audit': 'SEO',
  'technology-audit': 'Technology',
  'wordpress-audit': 'WordPress', // legacy: noble-reach predates rename
  'performance-audit': 'Performance',
  'accessibility-audit': 'Accessibility',
  'analytics-audit': 'Analytics',
  'security-audit': 'Security',
};

export const AUDIT_ORDER = ['seo-audit', 'technology-audit', 'wordpress-audit', 'performance-audit', 'accessibility-audit', 'analytics-audit', 'security-audit'];

export interface Report {
  client: string;
  clientName: string;
  slug: string;
  title: string;
  auditType: string;
  content: string;
}

export function getClients(): string[] {
  if (!existsSync(CLIENTS_DIR)) return [];
  return readdirSync(CLIENTS_DIR).filter((d: string) => {
    const fullPath = join(CLIENTS_DIR, d);
    return !d.startsWith('.') && statSync(fullPath).isDirectory();
  });
}

export function getClientName(client: string): string {
  const claudePath = join(CLIENTS_DIR, client, 'CLAUDE.md');
  if (!existsSync(claudePath)) return formatSlug(client);
  const content = readFileSync(claudePath, 'utf-8');
  // First line is like: # Noble Reach Foundation — Pre-Redesign Audit
  const match = content.match(/^#\s+(.+?)\s+[—–-]/m);
  return match ? match[1].trim() : formatSlug(client);
}

export function getClientReports(client: string): Report[] {
  const reports: Report[] = [];
  const clientName = getClientName(client);
  const clientDir = join(CLIENTS_DIR, client);

  for (const auditType of AUDIT_ORDER) {
    const reportsDir = join(clientDir, auditType, 'reports');
    if (!existsSync(reportsDir)) continue;

    const files = readdirSync(reportsDir)
      .filter((f: string) => f.endsWith('.md') && !f.toLowerCase().startsWith('readme'))
      .sort();

    for (const file of files) {
      const filePath = join(reportsDir, file);
      const content = readFileSync(filePath, 'utf-8');
      const title = extractTitle(content) || formatSlug(file.replace('.md', ''));
      const slug = file.replace('.md', '');
      reports.push({ client, clientName, slug, title, auditType, content });
    }
  }

  return reports;
}

export function getAllReports(): Report[] {
  return getClients().flatMap(client => getClientReports(client));
}

function extractTitle(content: string): string | null {
  const match = content.match(/^#\s+(.+)$/m);
  return match ? match[1].trim() : null;
}

function formatSlug(slug: string): string {
  return slug
    .replace(/^\d+-/, '')
    .replace(/-/g, ' ')
    .replace(/\b\w/g, c => c.toUpperCase());
}
